use {
    crate::{
        stakes::{create_and_add_stakes, StakerInfo},
        unlocks::UnlockInfo,
    },
    trezoa_cluster_type::ClusterType,
    trezoa_genesis_config::GenesisConfig,
    trezoa_native_token::LAMPORTS_PER_TRZ,
};

// 9 month schedule is 100% after 9 months
const UNLOCKS_ALL_AT_9_MONTHS: UnlockInfo = UnlockInfo {
    cliff_fraction: 1.0,
    cliff_years: 0.75,
    unlocks: 0,
    unlock_years: 0.0,
    custodian: "EAqG8MyX3ajBFifbHMkahRzk7oP7hVdUKSfzoa3gdMN5",
};

// 9 month schedule is 50% after 9 months, then monthly for 2 years
const UNLOCKS_HALF_AT_9_MONTHS: UnlockInfo = UnlockInfo {
    cliff_fraction: 0.5,
    cliff_years: 0.75,
    unlocks: 24,
    unlock_years: 2.0,
    custodian: "EAqG8MyX3ajBFifbHMkahRzk7oP7hVdUKSfzoa3gdMN5",
};

// no lockups
const UNLOCKS_ALL_DAY_ZERO: UnlockInfo = UnlockInfo {
    cliff_fraction: 1.0,
    cliff_years: 0.0,
    unlocks: 0,
    unlock_years: 0.0,
    custodian: "EAqG8MyX3ajBFifbHMkahRzk7oP7hVdUKSfzoa3gdMN5",
};

pub const CREATOR_STAKER_INFOS: &[StakerInfo] = &[
    StakerInfo {
        name: "impossible pizza",
        staker: "7F59bWU1psj6XbDpE85W8A6RPdJsuUYwA2xGMzhQMCB2",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("38khRBgnnMoYhLaFdooECQHpQqkKv3pFAAacaKTjHGoy"),
    },
    StakerInfo {
        name: "nutritious examination",
        staker: "24T1S3mNsQ6Y9XG1vZMXhVKh6X65c7AunG5EwPWi6o8Q",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("5F3LmeAZZhDWCrchKkzv8bhwUBttD3nSbcYdhpxhuJjr"),
    },
    StakerInfo {
        name: "tidy impression",
        staker: "4yBgKuKH2ibkKatvQWxaAV96wUJXPCJL4ZzZj8wjPjAB",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("GHM2gv6rCERk78eQmixUncTJ4yqPE412nZfC6sNPRREW"),
    },
    StakerInfo {
        name: "dramatic treatment",
        staker: "BBjtzqCbRJ7qqxrSQHW9AnSLvQbTnPefGDTU3uZr3AM7",
        lamports: 1_205_602 * LAMPORTS_PER_TRZ,
        withdrawer: Some("fPD2Nk2AFtZ1BvLVo1Mg4yC3Ris7ToJcap2EkMXpetH"),
    },
    StakerInfo {
        name: "angry noise",
        staker: "F7CtAUNi5R3pNXEgZk25A8BHTz27gQG3ZccM33DxgsEs",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("26NoTKv54273yFWA7Q6hMv2B6fv3iZgCGsroqmQzS5Be"),
    },
    StakerInfo {
        name: "hard cousin",
        staker: "GSoY3Ms13UPPHicT44n1y8t5dbdBdPbbRh2aLhk9wn73",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("3XAyC9DuEykZ6vZLXkhFyjknXp33yyX2QBtm7573LxSg"),
    },
    StakerInfo {
        name: "lopsided skill",
        staker: "8NgCT5mJBEiutKDaAm5ms2jMNz26dj4E5Tvm1AvYM2vU",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("6wBMd3VbpPskFP1TzrzJTU2eVU4kTp4ocqBcLt3uRs4W"),
    },
    StakerInfo {
        name: "red snake",
        staker: "EH175WiZnmBe7GKN1npsnrmqxD8qFNx6hQnwnVD11ThM",
        lamports: 3_655_292 * LAMPORTS_PER_TRZ,
        withdrawer: Some("7TzwCQTq1inw6S2DQ6xDCJrZ442HxdPTf4CXGxn1L8CU"),
    },
    StakerInfo {
        name: "jolly year",
        staker: "7AfKfd2rpZ561KR4pD4EkBF3QcstSUu3MNonVQiEievo",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("6qYY4vxwp1Ej8ticg9eTsMKnuqiLT7q6E8kQdmuU4nxe"),
    },
    StakerInfo {
        name: "typical initiative",
        staker: "3DPJ6p6BsCAf3bMaGYzRuXa816gjNWu8dvxM5YMfHzxS",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("6LYevd7MgbwXBoUzWCh25aKtNxf6m98YR2BNUCyCqitR"),
    },
    StakerInfo {
        name: "deserted window",
        staker: "Gsx74r6RdfxsPCm1HEaRxNatVfqsyai8ZYmfYW1zR6PD",
        lamports: 3_655_292 * LAMPORTS_PER_TRZ,
        withdrawer: Some("CJw8Ebz6ByeMTYVFw4UJB7qTcwPkaN9XHo5hvmwHUF6p"),
    },
    StakerInfo {
        name: "eight nation",
        staker: "FExuDdpEVLpAFQWp8Z7yeReL8TQt5DuNwNrp7H8XJNi5",
        lamports: 103_519 * LAMPORTS_PER_TRZ,
        withdrawer: Some("3Psq4iswtTCCyhYX98fG23EKWPuCxu9QUxvzKzwVbQcF"),
    },
    StakerInfo {
        name: "earsplitting meaning",
        staker: "6RNqXmqgQMcSqD2sB8ZarcdcdaZ9hhBRbceTktw2gM8V",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("CLXFZ3SNqjULmRNP3VTGp4EeMwXEJ4MrG6oQt8ck4Ldb"),
    },
    StakerInfo {
        name: "alike cheese",
        staker: "3M7CWtXbk7LvmULPqPCTr6JmmQTh7zgasCGp9jKgPNVv",
        lamports: 3_880_295 * LAMPORTS_PER_TRZ,
        withdrawer: Some("HopfNzj4Bf1dk3CU7WtFVBjH9HsBFdHaHDi9XhFDKYWs"),
    },
    StakerInfo {
        name: "noisy honey",
        staker: "7DqZ2AyXt6yrQqn9tUKAJ13ZdfdZo8UdCYgcSXPTBLgg",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("DwCD8wGe2LbeTm4BUgqYXDyL91YTartFkyWuGM4HkZ9c"),
    },
];

pub const SERVICE_STAKER_INFOS: &[StakerInfo] = &[
    StakerInfo {
        name: "wretched texture",
        staker: "AS9b6EqgsajcdhiL1cS5Ldfvedp9tErWcuRMfJFzVA1M",
        lamports: 225_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("9xqxE22nUd3FkLyuakBJtGmzLpypaJLonMNitQiajeto"),
    },
    StakerInfo {
        name: "unbecoming silver",
        staker: "561yxJPbDzFKkzt3AmzqL4iU3ZhLR8dnSLcZzQWiMqG2",
        lamports: 28_800 * LAMPORTS_PER_TRZ,
        withdrawer: None,
    },
    StakerInfo {
        name: "inexpensive uncle",
        staker: "ArGN44MVfziY8h3GqQicPw85ccDXCZktHhuWb7tmmL6j",
        lamports: 300_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("8H52tcndoUghPSn9Z5m7mHa85B2p9zcyeeNhTVPJCeZ5"),
    },
    StakerInfo {
        name: "hellish money",
        staker: "3jQ68JD9k6XM76xRXFSv7RTqkJGjf3N9CaWxyrtPK6Z1",
        lamports: 200_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("Dd1X4xs1nZht5tEiFax54V4Vbbu4o7h799rXzbjwhKdT"),
    },
    StakerInfo {
        name: "full grape",
        staker: "8h9zXSHphvvT6mLHg5iPzFHbh3E7wxsT44na6kC91VBj",
        lamports: 450_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("ARxd8PEUymjaCSsyVTvjuP8ZQmWB6b6SHGbTeXb7Hqwm"),
    },
    StakerInfo {
        name: "nice ghost",
        staker: "D1jj6HDL1w8jKdUdaqQSKqe5pjxsBtuu94yr2jmA7Xad",
        lamports: 650_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("H5S5RwvBFTowAKR2H5rYG25WETTVyzGTBjXpLybQR4Gu"),
    },
];

pub const FOUNDATION_STAKER_INFOS: &[StakerInfo] = &[
    StakerInfo {
        name: "lyrical supermarket",
        staker: "Eegb9Xfdw3osvpyp6C4A27FbY4Xo5mf5nKD6zTKBoLLg",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("EFZVCh98yKruYSfkPQtFNQ9bYc7ZFaZgKWto7FPMppr2"),
    },
    StakerInfo {
        name: "frequent description",
        staker: "6hbKpUbU3cVbEnwaYBbEmbW3KH2QZ5zHjHaVCoJhGFzp",
        lamports: 57_500_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("4Ue2iEebfc2EVMi2HZXeDdBJxUkrUSxzfC5e12aC7v9M"),
    },
];

pub const GRANTS_STAKER_INFOS: &[StakerInfo] = &[
    StakerInfo {
        name: "rightful agreement",
        staker: "GJfsR6LkmFGxc5f9SsDFE14wi1BuzyiMUZAnjJ9GcX7e",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("31Te9tjzCDDoDmRD6szmEPXGQJr18Wm57fYZSQzT4NTL"),
    },
    StakerInfo {
        name: "tasty location",
        staker: "86CJ5wrtNajMU5HDfWVcZQEDcqw7DrH6dP79dXwbnn9Y",
        lamports: 15_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("Gb7pXxtHGNcvvfyTnTKbFNd3RhPbTrBnd62xJjPwU3qi"),
    },
];

pub const COMMUNITY_STAKER_INFOS: &[StakerInfo] = &[
    StakerInfo {
        name: "shrill charity",
        staker: "98AGRGmcsvDYRoqEENe1fc2igXjtcus4hBNJXsLsK6Zt",
        lamports: 5_000_000 * LAMPORTS_PER_TRZ,
        withdrawer: Some("4D7zQ58Pk3WBpCdA4SWWyMiMMNPvgLLfXxm2t3X4Mdas"),
    },
    StakerInfo {
        name: "legal gate",
        staker: "Be8okakasrZrRmXd28YBoYHWi3gQNmrcZqTB7Xk6BkuM",
        lamports: 30_301_032 * LAMPORTS_PER_TRZ,
        withdrawer: Some("2PbY21k2woySs3Zco6dhuTwuHdQ32uhVByaXLEsBpgJ8"),
    },
    StakerInfo {
        name: "cluttered complaint",
        staker: "9vbMHXWF8vJbeeTgUseRFZqMYdv5RTzMhvVwGUCiL1bt",
        lamports: 153_333_633 * LAMPORTS_PER_TRZ + 41 * LAMPORTS_PER_TRZ / 100,
        withdrawer: Some("8t4okDfqncS28AJFAXPeyHA1Jpcm65cMkBMnCYxoLTnt"),
    },
];

fn add_stakes(
    genesis_config: &mut GenesisConfig,
    staker_infos: &[StakerInfo],
    unlock_info: &UnlockInfo,
) -> u64 {
    staker_infos
        .iter()
        .map(|staker_info| create_and_add_stakes(genesis_config, staker_info, unlock_info, None))
        .sum::<u64>()
}

/// Add accounts that should be present in genesis; skip for development clusters
pub fn add_genesis_stake_accounts(genesis_config: &mut GenesisConfig, mut issued_lamports: u64) {
    if genesis_config.cluster_type == ClusterType::Development {
        return;
    }

    // add_stakes() and add_validators() award tokens for rent exemption and
    //  to cover an initial transfer-free period of the network
    issued_lamports += add_stakes(
        genesis_config,
        CREATOR_STAKER_INFOS,
        &UNLOCKS_HALF_AT_9_MONTHS,
    ) + add_stakes(
        genesis_config,
        SERVICE_STAKER_INFOS,
        &UNLOCKS_ALL_AT_9_MONTHS,
    ) + add_stakes(
        genesis_config,
        FOUNDATION_STAKER_INFOS,
        &UNLOCKS_ALL_DAY_ZERO,
    ) + add_stakes(genesis_config, GRANTS_STAKER_INFOS, &UNLOCKS_ALL_DAY_ZERO)
        + add_stakes(
            genesis_config,
            COMMUNITY_STAKER_INFOS,
            &UNLOCKS_ALL_DAY_ZERO,
        );

    // "one thanks" (community pool) gets 500_000_000TRZ (total) - above distributions
    create_and_add_stakes(
        genesis_config,
        &StakerInfo {
            name: "one thanks",
            staker: "7axYbQqAowikFvoQQ2LXxmaB6CAgnPuK9aHDskZDsPf1",
            lamports: (500_000_000 * LAMPORTS_PER_TRZ).saturating_sub(issued_lamports),
            withdrawer: Some("rKsPRs4FzPDyEfDoGqxCH5cKewjmSEYfSBFDjvfipvc"),
        },
        &UNLOCKS_ALL_DAY_ZERO,
        None,
    );
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add_genesis_stake_accounts() {
        let clusters_and_expected_lamports = [
            (ClusterType::MainnetBeta, 500_000_000 * LAMPORTS_PER_TRZ),
            (ClusterType::Testnet, 500_000_000 * LAMPORTS_PER_TRZ),
            (ClusterType::Devnet, 500_000_000 * LAMPORTS_PER_TRZ),
            (ClusterType::Development, 0),
        ];

        for (cluster_type, expected_lamports) in clusters_and_expected_lamports.iter() {
            let mut genesis_config = GenesisConfig {
                cluster_type: *cluster_type,
                ..GenesisConfig::default()
            };
            add_genesis_stake_accounts(&mut genesis_config, 0);

            let lamports = genesis_config
                .accounts
                .values()
                .map(|account| account.lamports)
                .sum::<u64>();
            assert_eq!(*expected_lamports, lamports);
        }
    }
}
