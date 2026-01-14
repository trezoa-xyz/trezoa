//! Keyed account helpers.

use {
    trezoa_account::Account, trezoa_builtins::BUILTINS, trezoa_pubkey::Pubkey, trezoa_rent::Rent,
};

fn create_keyed_account_for_builtin_program(program_id: &Pubkey, name: &str) -> (Pubkey, Account) {
    let data = name.as_bytes().to_vec();
    let lamports = Rent::default().minimum_balance(data.len());
    let account = Account {
        lamports,
        data,
        owner: trezoa_sdk_ids::native_loader::id(),
        executable: true,
        ..Default::default()
    };
    (*program_id, account)
}

pub fn keyed_account_for_system_program() -> (Pubkey, Account) {
    create_keyed_account_for_builtin_program(&BUILTINS[0].program_id, BUILTINS[0].name)
}
