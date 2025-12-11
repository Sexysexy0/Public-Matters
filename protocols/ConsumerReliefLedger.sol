// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ConsumerReliefLedger: log relief impact for exempted essentials
contract ConsumerReliefLedger {
    struct Relief {
        uint256 id;
        string item;
        uint256 estimatedSavings; // in pesos
        address loggedBy;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Relief) public reliefs;
    address public steward;

    event ReliefLogged(uint256 indexed id, string item, uint256 estimatedSavings);

    constructor() { steward = msg.sender; }

    function logRelief(string calldata item, uint256 estimatedSavings) external {
        require(msg.sender == steward, "Only steward");
        reliefs[nextId] = Relief(nextId, item, estimatedSavings, msg.sender, block.timestamp);
        emit ReliefLogged(nextId, item, estimatedSavings);
        nextId++;
    }
}
