#![allow(incomplete_features)]
#![cfg_attr(RUSTC_WITH_SPECIALIZATION, feature(specialization))]
#![cfg_attr(RUSTC_NEEDS_PROC_MACRO_HYGIENE, feature(proc_macro_hygiene))]

#[cfg(not(target_os = "trezoa"))]
pub mod processor;

#[deprecated(
    since = "1.17.0",
    note = "Please use `trezoa_program::address_lookup_table` instead"
)]
pub use trezoa_program::address_lookup_table::{
    error, instruction,
    program::{check_id, id, ID},
    state,
};
