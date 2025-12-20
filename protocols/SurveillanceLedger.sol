// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SurveillanceLedger: record public reactions to surveillance practices
contract SurveillanceLedger {
    struct Reaction {
        uint256 id;
        string user;
        string concern;     // "Keystroke Lag", "Data Collection"
        string sentiment;   // "Terrifying", "Distrust"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Reaction) public reactions;
    mapping(address => bool) public stewards;

    event ReactionLogged(uint256 indexed id, string user, string concern, string sentiment);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logReaction(string calldata user, string calldata concern, string calldata sentiment) external {
        require(stewards[msg.sender], "Only steward");
        reactions[nextId] = Reaction(nextId, user, concern, sentiment, block.timestamp);
        emit ReactionLogged(nextId, user, concern, sentiment);
        nextId++;
    }
}
