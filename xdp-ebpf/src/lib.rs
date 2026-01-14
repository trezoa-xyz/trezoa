#![cfg_attr(
    not(feature = "trezoa-unstable-api"),
    deprecated(
        since = "3.1.0",
        note = "This crate has been marked for formal inclusion in the Trezoa-team Unstable API. From \
                v4.0.0 onward, the `trezoa-unstable-api` crate feature must be specified to \
                acknowledge use of an interface that may break without warning."
    )
)]
// Activate some of the Rust 2024 lints to make the future migration easier.
#![warn(if_let_rescope)]
#![warn(keyword_idents_2024)]
#![warn(rust_2024_incompatible_pat)]
#![warn(tail_expr_drop_order)]
#![warn(unsafe_attr_outside_unsafe)]
#![warn(unsafe_op_in_unsafe_fn)]
#![no_std]

#[cfg(all(target_os = "linux", not(target_arch = "bpf")))]
#[unsafe(no_mangle)]
pub static TREZOA_XDP_EBPF_PROGRAM: [u8; aya::include_bytes_aligned!(concat!(
    env!("CARGO_MANIFEST_DIR"),
    "/trezoa-xdp-prog"
))
.len()] = unsafe {
    core::ptr::read(
        aya::include_bytes_aligned!(concat!(env!("CARGO_MANIFEST_DIR"), "/trezoa-xdp-prog"))
            .as_ptr()
            .cast(),
    )
};
