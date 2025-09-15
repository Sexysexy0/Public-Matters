// SPDX-License-Identifier: SovereignSanctum
pragma solidity ^0.8.19;

contract DigitalSovereigntyRouter {
    struct SovereignAccess {
        address user;
        bool biometricRequired;
        bool flaggedByBank;
        string fallbackProtocol; // e.g., "Lightning", "Multisig", "Cold Wallet"
        string dignityNote;
        bool restored;
    }

    mapping(address => SovereignAccess) public accessRecords;

    event SovereignTagged(address user, string fallbackProtocol);
    event AccessRestored(address user);

    function tagSovereign(address user, bool biometricRequired, bool flaggedByBank, string memory fallbackProtocol, string memory dignityNote) public {
        accessRecords[user] = SovereignAccess(user, biometricRequired, flaggedByBank, fallbackProtocol, dignityNote, false);
        emit SovereignTagged(user, fallbackProtocol);
    }

    function restoreAccess(address user) public {
        accessRecords[user].restored = true;
        emit AccessRestored(user);
    }

    function getAccessStatus(address user) public view returns (SovereignAccess memory) {
        return accessRecords[user];
    }
}
