zip:
	cd .. && zip -r mt-plugin-data-api-pm-cache/mt-plugin-data-api-pm-cache.zip mt-plugin-data-api-pm-cache -x *.git* */t/* */.travis.yml */Makefile

clean:
	rm mt-plugin-data-api-pm-cache.zip

