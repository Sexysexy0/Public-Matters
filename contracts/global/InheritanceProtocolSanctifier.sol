// SPDX-License-Identifier: LegacySanctum
pragma solidity ^0.8.19;

contract InheritanceProtocolSanctifier {
    struct LegacySignal {
        string walletID;
        string beneficiary;
        uint256 unlockAge;
        bool executed;
        string stewardNote;
    }

    mapping(string => LegacySignal) public legacyRegistry;

    event LegacyTagged(string walletID, string beneficiary);
    event LegacyExecuted(string walletID);

    function tagLegacy(string memory walletID, string memory beneficiary, uint256 unlockAge, string memory stewardNote) public {
        legacyRegistry[walletID] = LegacySignal(walletID, beneficiary, unlockAge, false, stewardNote);
        emit LegacyTagged(walletID, beneficiary);
    }

    function executeLegacy(string memory walletID, uint256 age) public {
        require(age >= legacyRegistry[walletID].unlockAge, "Unlock age not reached");
        legacyRegistry[walletID].executed = true;
        emit LegacyExecuted(walletID);
    }

    function getLegacyStatus(string memory walletID) public view returns (LegacySignal memory) {
        return legacyRegistry[walletID];
    }
}
