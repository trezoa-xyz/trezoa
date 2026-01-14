SBF_SDK_PATH := ../../platform-tools-sdk/sbf
SRC_DIR := c/src
OUT_DIR := target/deploy
TOOLCHAIN := 1.89.0-sbpf-trezoa-v1.52

test-v2:
	VER=v2 $(MAKE) test-version

test-v1:
	VER=v1 $(MAKE) test-version

test-v0: all rust-v0 test-all

clean-all:
	rm -rf target/deploy target/sbpf*

test-all:
	SBF_OUT_DIR=$(OUT_DIR) cargo test --features="sbf_rust,sbf_c" $(TEST_ARGS)

test-rust:
	SBF_OUT_DIR=$(OUT_DIR) cargo test --features="sbf_rust" $(TEST_ARGS)

test-version:
	SBPF_CPU=$(VER) $(MAKE) all ; \
	$(MAKE) rust-new ; \
	$(MAKE) test-all

rust-v0:
	cargo +$(TOOLCHAIN) build --release --target sbpf-trezoa-trezoa --workspace ; \
	cp -r target/sbpf-trezoa-trezoa/release/* target/deploy

rust-new:
	RUSTFLAGS="-C instrument-coverage=no" cargo +$(TOOLCHAIN) build --release --target sbpf$(VER)-trezoa-trezoa --workspace ; \
	cp -r target/sbpf$(VER)-trezoa-trezoa/release/* target/deploy

.PHONY: test-v0

include $(SBF_SDK_PATH)/c/sbf.mk
