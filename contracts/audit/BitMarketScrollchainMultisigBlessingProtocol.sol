// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainMultisigBlessingProtocol {
    address[] public guardians;
    uint public requiredBlessings;

    mapping(bytes32 => uint) public blessingVotes;

    event BlessingProposed(bytes32 txHash);
    event BlessingConfirmed(bytes32 txHash);

    constructor(address[] memory _guardians, uint _requiredBlessings) {
        guardians = _guardians;
        requiredBlessings = _requiredBlessings;
    }

    function proposeBlessing(bytes32 txHash) public {
        require(isGuardian(msg.sender), "Not a guardian");
        blessingVotes[txHash]++;
        emit BlessingProposed(txHash);

        if (blessingVotes[txHash] >= requiredBlessings) {
            emit BlessingConfirmed(txHash);
        }
    }

    function isGuardian(address addr) internal view returns (bool) {
        for (uint i = 0; i < guardians.length; i++) {
            if (guardians[i] == addr) return true;
        }
        return false;
    }
}
