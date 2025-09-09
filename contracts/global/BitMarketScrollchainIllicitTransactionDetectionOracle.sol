// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainIllicitTransactionDetectionOracle {
    address public steward;
    mapping(string => bool) public flaggedWallets;
    mapping(string => string) public anomalyType;

    event WalletFlagged(string wallet, string anomaly, uint timestamp);

    function flagWallet(string memory wallet, string memory anomaly) public {
        flaggedWallets[wallet] = true;
        anomalyType[wallet] = anomaly;
        emit WalletFlagged(wallet, anomaly, block.timestamp);
    }

    function isFlagged(string memory wallet) public view returns (bool) {
        return flaggedWallets[wallet];
    }

    function getAnomalyType(string memory wallet) public view returns (string memory) {
        return anomalyType[wallet];
    }
}
