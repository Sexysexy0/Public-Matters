// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NarrativeLedger: log narratives and their resonance metrics
contract NarrativeLedger {
    struct Narrative {
        uint256 id;
        string title;
        string uri;           // source or video/article link
        uint256 resonance;    // score (e.g., reactions, shares)
        bool hearsay;         // flagged as hearsay/opinion
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Narrative) public narratives;
    mapping(address => bool) public stewards;

    event NarrativeLogged(uint256 indexed id, string title, bool hearsay, uint256 resonance);
    event ResonanceUpdated(uint256 indexed id, uint256 resonance);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logNarrative(string calldata title, string calldata uri, bool hearsay, uint256 resonance) external {
        require(stewards[msg.sender], "Only steward");
        narratives[nextId] = Narrative(nextId, title, uri, resonance, hearsay, block.timestamp);
        emit NarrativeLogged(nextId, title, hearsay, resonance);
        nextId++;
    }

    function updateResonance(uint256 id, uint256 resonance) external {
        require(stewards[msg.sender], "Only steward");
        narratives[id].resonance = resonance;
        emit ResonanceUpdated(id, resonance);
    }
}
