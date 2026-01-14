#![cfg_attr(
    not(feature = "trezoa-unstable-api"),
    deprecated(
        since = "3.1.0",
        note = "This crate has been marked for formal inclusion in the Trezoa-team Unstable API. From \
                v4.0.0 onward, the `trezoa-unstable-api` crate feature must be specified to \
                acknowledge use of an interface that may break without warning."
    )
)]
//! Trezoa compute budget types and default configurations.
#![cfg_attr(feature = "frozen-abi", feature(min_specialization))]

pub mod compute_budget;
pub mod compute_budget_limits;
