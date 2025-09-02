// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title CivicReliefOracle
/// @dev Emits relief based on emotional APR and damay clause triggers

contract CivicReliefOracle {
    address public steward;
    mapping(address => uint256) public reliefLedger;

    event ReliefEmitted(address indexed steward, uint256 amount, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function emitRelief(address recipient, uint256 amount, string memory reason) public onlySteward {
        reliefLedger[recipient] += amount;
        emit ReliefEmitted(recipient, amount, reason);
    }

    function getRelief(address stewardAddr) public view returns (uint256) {
        return reliefLedger[stewardAddr];
    }
}
