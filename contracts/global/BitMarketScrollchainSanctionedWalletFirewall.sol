// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainSanctionedWalletFirewall {
    address public steward;
    mapping(string => bool) public blockedWallets;
    mapping(string => string) public threatType;

    event WalletBlocked(string wallet, string threat, uint timestamp);

    function blockWallet(string memory wallet, string memory threat) public {
        blockedWallets[wallet] = true;
        threatType[wallet] = threat;
        emit WalletBlocked(wallet, threat, block.timestamp);
    }

    function isBlocked(string memory wallet) public view returns (bool) {
        return blockedWallets[wallet];
    }

    function getThreatType(string memory wallet) public view returns (string memory) {
        return threatType[wallet];
    }
}
