format:
	deno fmt scripts

fetch_external:
	curl \
		--output data/block-the-eu-cookie-shit-list.txt \
		--silent \
		--show-error \
		--location \
		--fail \
		--url https://raw.githubusercontent.com/r4vi/block-the-eu-cookie-shit-list/master/filterlist.txt
	curl \
		--output data/dont-push-me.txt \
		--silent \
		--show-error \
		--location \
		--fail \
		--url https://raw.githubusercontent.com/caffeinewriter/DontPushMe/master/filterlist.txt

blocklist:
	deno run --allow-read=./data --allow-env=MINIFY scripts/build-blocklist.js

xcode:
ifeq ("$(CONFIGURATION_BUILD_DIR)","")
	$(error CONFIGURATION_BUILD_DIR env is not set, make this command is run from Xcode)
endif
ifeq ("$(UNLOCALIZED_RESOURCES_FOLDER_PATH)","")
	$(error UNLOCALIZED_RESOURCES_FOLDER_PATH env is not set, make this command is run from Xcode)
endif
	mkdir -p "$(CONFIGURATION_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)"
	MINIFY=1 make blocklist --silent > "$(CONFIGURATION_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/blockerList.json"
