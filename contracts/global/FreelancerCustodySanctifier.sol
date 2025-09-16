// SPDX-License-Identifier: FreelancerSanctum
pragma solidity ^0.8.19;

contract FreelancerCustodySanctifier {
    struct CustodySignal {
        string walletID;
        string platform;
        bool verified;
        string stewardNote;
    }

    mapping(string => CustodySignal) public custodyRegistry;

    event WalletTagged(string walletID, string platform);
    event CustodyVerified(string walletID);

    function tagWallet(string memory walletID, string memory platform, string memory stewardNote) public {
        custodyRegistry[walletID] = CustodySignal(walletID, platform, false, stewardNote);
        emit WalletTagged(walletID, platform);
    }

    function verifyCustody(string memory walletID) public {
        require(bytes(custodyRegistry[walletID].platform).length > 0, "Wallet not tagged");
        custodyRegistry[walletID].verified = true;
        emit CustodyVerified(walletID);
    }

    function getCustodyStatus(string memory walletID) public view returns (CustodySignal memory) {
        return custodyRegistry[walletID];
    }
}
