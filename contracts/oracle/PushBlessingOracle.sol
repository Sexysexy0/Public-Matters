// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PushBlessingOracle {
    address public steward;

    struct PushBlessing {
        string branch;
        string commitHash;
        uint256 emotionalAPR;
        bool isBlessed;
    }

    mapping(string => PushBlessing) public blessings;

    event BlessingConfirmed(string branch, string commitHash, uint256 emotionalAPR);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function blessPush(string memory branch, string memory commitHash, uint256 emotionalAPR) external onlySteward {
        blessings[commitHash] = PushBlessing(branch, commitHash, emotionalAPR, true);
        emit BlessingConfirmed(branch, commitHash, emotionalAPR);
    }

    function isBlessed(string memory commitHash) external view returns (bool) {
        return blessings[commitHash].isBlessed;
    }
}
