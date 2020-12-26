format:
	deno fmt scripts

check_format:
	deno fmt --check scripts

test:
	deno test

fetch_external:
	deno run --allow-write=./data --allow-net scripts/fetch-external.js

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
