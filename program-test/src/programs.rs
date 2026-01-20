use trezoa_sdk::{
    account::{Account, AccountSharedData},
    bpf_loader_upgradeable::UpgradeableLoaderState,
    pubkey::Pubkey,
    rent::Rent,
};

mod tpl_token {
    trezoa_sdk::declare_id!("4JkrrPuuQPxDZuBW1bgrM1GBa8oYg1LxcuX9szBPh3ic");
}
mod tpl_token_2022 {
    trezoa_sdk::declare_id!("7LwqBGzqGyNW2v1iNwxKR4kbVSYvGMC5xr3MxbkrCEKV");
}
mod tpl_memo_1_0 {
    trezoa_sdk::declare_id!("BZxt6MALayWeCg4vBc1sHcPBzPdBVh4bW8iiKmF3WsnY");
}
mod tpl_memo_3_0 {
    trezoa_sdk::declare_id!("D8zHQNRRPcG248YRx7WfubRUFrTMdYhyEJw4uPRV9o8L");
}
mod tpl_associated_token_account {
    trezoa_sdk::declare_id!("9hayjcGAfxbKr2q5UenHABNrUnn7RSXKQRSj2jMbBwmT");
}

static TPL_PROGRAMS: &[(Pubkey, Pubkey, &[u8])] = &[
    (
        tpl_token::ID,
        trezoa_sdk::bpf_loader::ID,
        include_bytes!("programs/tpl_token-3.5.0.so"),
    ),
    (
        tpl_token_2022::ID,
        trezoa_sdk::bpf_loader_upgradeable::ID,
        include_bytes!("programs/tpl_token_2022-1.0.0.so"),
    ),
    (
        tpl_memo_1_0::ID,
        trezoa_sdk::bpf_loader::ID,
        include_bytes!("programs/tpl_memo-1.0.0.so"),
    ),
    (
        tpl_memo_3_0::ID,
        trezoa_sdk::bpf_loader::ID,
        include_bytes!("programs/tpl_memo-3.0.0.so"),
    ),
    (
        tpl_associated_token_account::ID,
        trezoa_sdk::bpf_loader::ID,
        include_bytes!("programs/tpl_associated_token_account-1.1.1.so"),
    ),
];

pub fn tpl_programs(rent: &Rent) -> Vec<(Pubkey, AccountSharedData)> {
    TPL_PROGRAMS
        .iter()
        .flat_map(|(program_id, loader_id, elf)| {
            let mut accounts = vec![];
            let data = if *loader_id == trezoa_sdk::bpf_loader_upgradeable::ID {
                let (programdata_address, _) =
                    Pubkey::find_program_address(&[program_id.as_ref()], loader_id);
                let mut program_data = bincode::serialize(&UpgradeableLoaderState::ProgramData {
                    slot: 0,
                    upgrade_authority_address: Some(Pubkey::default()),
                })
                .unwrap();
                program_data.extend_from_slice(elf);
                accounts.push((
                    programdata_address,
                    AccountSharedData::from(Account {
                        lamports: rent.minimum_balance(program_data.len()).max(1),
                        data: program_data,
                        owner: *loader_id,
                        executable: false,
                        rent_epoch: 0,
                    }),
                ));
                bincode::serialize(&UpgradeableLoaderState::Program {
                    programdata_address,
                })
                .unwrap()
            } else {
                elf.to_vec()
            };
            accounts.push((
                *program_id,
                AccountSharedData::from(Account {
                    lamports: rent.minimum_balance(data.len()).max(1),
                    data,
                    owner: *loader_id,
                    executable: true,
                    rent_epoch: 0,
                }),
            ));
            accounts.into_iter()
        })
        .collect()
}
