// contracts/CorruptionCritique.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CorruptionCritique
 * @notice Logs critiques of corruption fundamentalism and global context.
 */
contract CorruptionCritique {
    address public admin;

    struct Critique {
        string focus;       // "Fundamentalism", "GlobalIssue"
        string description;
        uint256 timestamp;
    }

    Critique[] public critiques;

    event CritiqueLogged(string focus, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCritique(string calldata focus, string calldata description) external onlyAdmin {
        critiques.push(Critique(focus, description, block.timestamp));
        emit CritiqueLogged(focus, description, block.timestamp);
    }

    function totalCritiques() external view returns (uint256) { return critiques.length; }

    function getCritique(uint256 id) external view returns (Critique memory) {
        require(id < critiques.length, "Invalid id");
        return critiques[id];
    }
}
