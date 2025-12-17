// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SenateMirror: record Senate reactions to missing budget items
contract SenateMirror {
    struct Reaction {
        uint256 id;
        string senator;     // "Loren Legarda"
        string issue;       // "Missing NEP Items"
        string sentiment;   // "Frustrated", "Demand Accountability"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Reaction) public reactions;
    mapping(address => bool) public stewards;

    event ReactionLogged(uint256 indexed id, string senator, string issue, string sentiment);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logReaction(string calldata senator, string calldata issue, string calldata sentiment) external {
        require(stewards[msg.sender], "Only steward");
        reactions[nextId] = Reaction(nextId, senator, issue, sentiment, block.timestamp);
        emit ReactionLogged(nextId, senator, issue, sentiment);
        nextId++;
    }
}
