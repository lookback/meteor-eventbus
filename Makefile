
test: package.js
	meteor test-packages --velocity --port 3010 --driver-package respondly:test-reporter ./

.PHONY: test
