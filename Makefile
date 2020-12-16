build:
	make fetch_blocklist
	make build_blocklist

format:
	deno fmt scripts

fetch_blocklist:
	curl \
		--output data/block-the-eu-cookie-shit-list.txt \
		--silent \
		--show-error \
		--location \
		--fail \
		--url https://raw.githubusercontent.com/r4vi/block-the-eu-cookie-shit-list/master/filterlist.txt

build_blocklist:
	deno run --allow-read=./data scripts/build-blocklist.js > Shared/blockerList.json
