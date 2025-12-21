// contracts/NarrativeAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title NarrativeAudit
 * @notice Mythic audit of narratives for communal resonance and validator-grade truth.
 */
contract NarrativeAudit {
    address public admin;

    struct Narrative {
        string theme;
        string verdict;   // "True", "False", "Mixed"
        string note;
        uint256 timestamp;
    }

    Narrative[] public narratives;

    event NarrativeLogged(string theme, string verdict, string note, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logNarrative(string calldata theme, string calldata verdict, string calldata note) external onlyAdmin {
        narratives.push(Narrative(theme, verdict, note, block.timestamp));
        emit NarrativeLogged(theme, verdict, note, block.timestamp);
    }

    function totalNarratives() external view returns (uint256) {
        return narratives.length;
    }

    function getNarrative(uint256 id) external view returns (Narrative memory) {
        require(id < narratives.length, "Invalid id");
        return narratives[id];
    }
}
