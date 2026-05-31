// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PhilosophyBridge
/// @notice Connects MisconceptionDefense, PhilosophyCouncil, and PhilosophyArchive
/// @dev Ensures unified governance and archival flow for Machiavelli scholarship

interface IMisconceptionDefense {
    function flagMisconception(string calldata category, string calldata details) external;
    function clearMisconception(uint256 id) external;
}

interface IPhilosophyCouncil {
    function createProposal(string calldata misconception, string calldata action) external;
    function executeProposal(uint256 id) external;
}

interface IPhilosophyArchive {
    function storeRecord(string calldata category, string calldata content) external;
}

contract PhilosophyBridge {
    address public guardian;
    IMisconceptionDefense public defense;
    IPhilosophyCouncil public council;
    IPhilosophyArchive public archive;

    event BridgeAction(string system, string action, string details, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian, address _defense, address _council, address _archive) {
        guardian = _guardian;
        defense = IMisconceptionDefense(_defense);
        council = IPhilosophyCouncil(_council);
        archive = IPhilosophyArchive(_archive);
    }

    /// @notice Flag a misconception and create council proposal
    function flagAndPropose(string calldata category, string calldata details, string calldata action) external onlyGuardian {
        defense.flagMisconception(category, details);
        council.createProposal(details, action);
        archive.storeRecord("Flagged Misconception", details);
        emit BridgeAction("Defense+Council", "Flag+Proposal", details, block.timestamp);
    }

    /// @notice Execute council decision and archive it
    function executeAndArchive(uint256 proposalId, string calldata content) external onlyGuardian {
        council.executeProposal(proposalId);
        archive.storeRecord("Council Decision", content);
        emit BridgeAction("Council+Archive", "Execute+Store", content, block.timestamp);
    }

    /// @notice Clear misconception and archive the action
    function clearAndArchive(uint256 id, string calldata content) external onlyGuardian {
        defense.clearMisconception(id);
        archive.storeRecord("Cleared Misconception", content);
        emit BridgeAction("Defense+Archive", "Clear+Store", content, block.timestamp);
    }
}
