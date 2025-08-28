// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract EntraIDAuditPulse {
    struct Identity {
        string name;
        bool isHuman;
        bool hasMFA;
        bool isGlobalAdmin;
    }

    Identity[] public identities;

    event RogueIdentityDetected(string name);
    event MFAGapDetected(string name);

    function addIdentity(string memory name, bool isHuman, bool hasMFA, bool isGlobalAdmin) public {
        identities.push(Identity(name, isHuman, hasMFA, isGlobalAdmin));
        if (!hasMFA) emit MFAGapDetected(name);
        if (!isHuman && isGlobalAdmin && !hasMFA) emit RogueIdentityDetected(name);
    }

    function audit() public view returns (uint rogueCount) {
        for (uint i = 0; i < identities.length; i++) {
            if (!identities[i].isHuman && identities[i].isGlobalAdmin && !identities[i].hasMFA) {
                rogueCount++;
            }
        }
    }
}
