TARGET = SwiftRedux

.PHONY: clean
clean:
	@swift package clean

.PHONY: format
format:
	@swift format -r -p -i .

.PHONY: lint
lint:
	@swift format lint -r -p --strict .

.PHONY: build
build:
	@swift build -Xswiftc -warnings-as-errors

.PHONY: build-tests
build-tests:
	@swift build --build-tests -Xswiftc -warnings-as-errors

.PHONY: build-release
build-release:
	@swift build -c release -Xswiftc -warnings-as-errors

.PHONY: test
test:
	@swift build --build-tests -Xswiftc -warnings-as-errors
	@swift test --skip-build
