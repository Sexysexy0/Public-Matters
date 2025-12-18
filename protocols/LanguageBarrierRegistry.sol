// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// LanguageBarrierRegistry: record language fluency and barriers
contract LanguageBarrierRegistry {
    struct Barrier {
        uint256 id;
        string candidate;
        string language;    // "English", "Tagalog"
        string fluency;     // "Fluent", "Basic", "Struggling"
        string impact;      // "Interview Performance", "Job Execution"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Barrier) public barriers;
    mapping(address => bool) public stewards;

    event BarrierLogged(uint256 indexed id, string candidate, string language, string fluency, string impact);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logBarrier(string calldata candidate, string calldata language, string calldata fluency, string calldata impact) external {
        require(stewards[msg.sender], "Only steward");
        barriers[nextId] = Barrier(nextId, candidate, language, fluency, impact, block.timestamp);
        emit BarrierLogged(nextId, candidate, language, fluency, impact);
        nextId++;
    }
}
