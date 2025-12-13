// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NewsBalanceDashboard: aggregate balance scores and provide comparative rankings
contract NewsBalanceDashboard {
    address public steward;

    struct Entry {
        uint256 id;
        string outlet;       // e.g., "GMA", "PTV", "ABS-CBN"
        uint256 score;       // balance score
        string classification; // Reliable, Unbalanced, Critical Bias
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Entry) public entries;
    mapping(address => bool) public stewards;

    event EntryLogged(uint256 indexed id, string outlet, uint256 score, string classification);

    constructor() { 
        steward = msg.sender; 
        stewards[steward] = true; 
    }

    function addSteward(address s) external {
        require(msg.sender == steward, "Only steward");
        stewards[s] = true;
    }

    function logEntry(string calldata outlet, uint256 score, string calldata classification) external {
        require(stewards[msg.sender], "Only steward");
        entries[nextId] = Entry(nextId, outlet, score, classification, block.timestamp);
        emit EntryLogged(nextId, outlet, score, classification);
        nextId++;
    }

    // Simple ranking: return top entry by score
    function topEntry() external view returns (Entry memory) {
        uint256 bestScore = 0;
        uint256 bestId = 0;
        for (uint256 i = 0; i < nextId; i++) {
            if (entries[i].score > bestScore) {
                bestScore = entries[i].score;
                bestId = i;
            }
        }
        return entries[bestId];
    }
}
