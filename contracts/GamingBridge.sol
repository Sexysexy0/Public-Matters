// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GamingBridge
/// @notice Connects GamingIndustryDefense, GamingCouncil, and GamingArchive
/// @dev Ensures unified governance and archival flow for gaming industry turbulence

interface IGamingIndustryDefense {
    function logCase(string calldata category, string calldata details) external;
    function clearCase(uint256 id) external;
}

interface IGamingCouncil {
    function createProposal(string calldata caseDetails, string calldata action) external;
    function executeProposal(uint256 id) external;
}

interface IGamingArchive {
    function storeRecord(string calldata category, string calldata content) external;
}

contract GamingBridge {
    address public guardian;
    IGamingIndustryDefense public defense;
    IGamingCouncil public council;
    IGamingArchive public archive;

    event BridgeAction(string system, string action, string details, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian, address _defense, address _council, address _archive) {
        guardian = _guardian;
        defense = IGamingIndustryDefense(_defense);
        council = IGamingCouncil(_council);
        archive = IGamingArchive(_archive);
    }

    /// @notice Log a case and create council proposal
    function logAndPropose(string calldata category, string calldata details, string calldata action) external onlyGuardian {
        defense.logCase(category, details);
        council.createProposal(details, action);
        archive.storeRecord("Logged Case", details);
        emit BridgeAction("Defense+Council", "Log+Proposal", details, block.timestamp);
    }

    /// @notice Execute council decision and archive it
    function executeAndArchive(uint256 proposalId, string calldata content) external onlyGuardian {
        council.executeProposal(proposalId);
        archive.storeRecord("Council Decision", content);
        emit BridgeAction("Council+Archive", "Execute+Store", content, block.timestamp);
    }

    /// @notice Clear case and archive the action
    function clearAndArchive(uint256 id, string calldata content) external onlyGuardian {
        defense.clearCase(id);
        archive.storeRecord("Cleared Case", content);
        emit BridgeAction("Defense+Archive", "Clear+Store", content, block.timestamp);
    }
}
