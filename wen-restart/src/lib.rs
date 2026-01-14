#![cfg_attr(
    not(feature = "trezoa-unstable-api"),
    deprecated(
        since = "3.1.0",
        note = "This crate has been marked for formal inclusion in the Trezoa-team Unstable API. From \
                v4.0.0 onward, the `trezoa-unstable-api` crate feature must be specified to \
                acknowledge use of an interface that may break without warning."
    )
)]
pub(crate) mod trezoa {
    pub(crate) mod wen_restart_proto {
        include!(concat!(env!("OUT_DIR"), "/trezoa.wen_restart_proto.rs"));
    }
}

pub(crate) mod heaviest_fork_aggregate;
pub(crate) mod last_voted_fork_slots_aggregate;
pub mod wen_restart;
