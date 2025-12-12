// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SpeechLedger: record public speech and commentary logs
contract SpeechLedger {
    struct Speech {
        uint256 id;
        address speaker;
        string contentURI;   // podcast, video, article
        bool publicOfficial; // true if about a public official
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Speech) public speeches;
    mapping(address => bool) public stewards;

    event SpeechLogged(uint256 indexed id, address speaker, string contentURI);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logSpeech(address speaker, string calldata contentURI, bool publicOfficial) external {
        require(stewards[msg.sender], "Only steward");
        speeches[nextId] = Speech(nextId, speaker, contentURI, publicOfficial, block.timestamp);
        emit SpeechLogged(nextId, speaker, contentURI);
        nextId++;
    }
}
