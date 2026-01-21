#![allow(clippy::arithmetic_side_effects)]
use {
    trezoa_cli::cli::{process_command, CliCommand, CliConfig},
    trezoa_commitment_config::CommitmentConfig,
    trezoa_faucet::faucet::run_local_faucet_with_unique_port_for_tests,
    trezoa_keypair::Keypair,
    trezoa_native_token::LAMPORTS_PER_TRZ,
    trezoa_net_utils::SocketAddrSpace,
    trezoa_rpc_client::nonblocking::rpc_client::RpcClient,
    trezoa_test_validator::TestValidator,
};

#[tokio::test(flavor = "multi_thread", worker_threads = 1)]
async fn test_cli_request_airdrop() {
    let mint_keypair = Keypair::new();
    let faucet_addr = run_local_faucet_with_unique_port_for_tests(mint_keypair.insecure_clone());
    let test_validator = TestValidator::async_with_no_fees(
        &mint_keypair,
        Some(faucet_addr),
        SocketAddrSpace::Unspecified,
    )
    .await;

    let mut bob_config = CliConfig::recent_for_tests();
    bob_config.json_rpc_url = test_validator.rpc_url();
    bob_config.command = CliCommand::Airdrop {
        pubkey: None,
        lamports: 50 * LAMPORTS_PER_TRZ,
    };
    let keypair = Keypair::new();
    bob_config.signers = vec![&keypair];

    let sig_response = process_command(&bob_config).await;
    sig_response.unwrap();

    let rpc_client =
        RpcClient::new_with_commitment(test_validator.rpc_url(), CommitmentConfig::processed());

    let balance = rpc_client
        .get_balance(&bob_config.signers[0].pubkey())
        .await
        .unwrap();
    assert_eq!(balance, 50 * LAMPORTS_PER_TRZ);
}
