# ─────────────────────────────────────────────────────────────────
# Makefile — Botflow remote Mac cloud build commands
#
# Typical flow on a remote Mac runner:
#   1. `make generate`  — produce MyApp.xcodeproj from project.yml
#   2. `make build`     — compile for the iOS Simulator
#   3. `make clean`     — wipe generated artefacts between runs
#
# Prerequisites (must be pre-installed on the runner):
#   • Xcode 16+   (xcodebuild)
#   • XcodeGen    (brew install xcodegen)
# ─────────────────────────────────────────────────────────────────

SCHEME      := MyApp
PROJECT     := MyApp.xcodeproj
SDK         := iphonesimulator
# Use the latest available simulator so the runner doesn't need a
# specific OS version pinned.
DESTINATION := platform=iOS Simulator,name=iPhone 16,OS=latest
BUILD_DIR   := .build

# ── Targets ───────────────────────────────────────────────────────

.PHONY: generate build clean open

## generate: Run XcodeGen to produce $(PROJECT) from project.yml.
##           Re-run after every Botflow file-injection pass.
generate:
	xcodegen generate --spec project.yml

## build: Compile the app for the iOS Simulator.
##        Implicitly runs `generate` first so the .xcodeproj is
##        always in sync with the current source tree.
build: generate
	xcodebuild \
		-project "$(PROJECT)" \
		-scheme  "$(SCHEME)"  \
		-sdk     "$(SDK)"     \
		-destination "$(DESTINATION)" \
		-derivedDataPath "$(BUILD_DIR)" \
		-parallelizeTargets \
		CODE_SIGN_IDENTITY="" \
		CODE_SIGNING_REQUIRED=NO \
		CODE_SIGNING_ALLOWED=NO \
		build | xcpretty || xcodebuild \
			-project "$(PROJECT)" \
			-scheme  "$(SCHEME)"  \
			-sdk     "$(SDK)"     \
			-destination "$(DESTINATION)" \
			-derivedDataPath "$(BUILD_DIR)" \
			CODE_SIGN_IDENTITY="" \
			CODE_SIGNING_REQUIRED=NO \
			CODE_SIGNING_ALLOWED=NO \
			build

## clean: Remove generated project and build artefacts.
clean:
	rm -rf "$(PROJECT)" "$(BUILD_DIR)"
	@echo "Cleaned $(PROJECT) and $(BUILD_DIR)."

## open: Generate and open the project in Xcode (local dev only).
open: generate
	open "$(PROJECT)"
