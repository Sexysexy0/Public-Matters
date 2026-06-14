// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ResearchQualityLedger
/// @notice Ledger covenant to track research proposals and funding success
contract ResearchQualityLedger {
    address public overseer;
    uint256 public entryCount;

    struct ResearchEntry {
        uint256 id;
        string institution;   // university or ORIC name
        uint256 proposals;    // number of proposals submitted
        uint256 funded;       // number of proposals funded
        string domain;        // research domain (STEM, social sciences, etc.)
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ResearchEntry) public entries;

    event ResearchLogged(uint256 indexed id, string institution, uint256 proposals, uint256 funded, string domain, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs research quality entry
    function logResearch(string calldata institution, uint256 proposals, uint256 funded, string calldata domain, string calldata notes) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ResearchEntry({
            id: entryCount,
            institution: institution,
            proposals: proposals,
            funded: funded,
            domain: domain,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ResearchLogged(entryCount, institution, proposals, funded, domain, notes);
    }

    /// @notice Citizens can view research quality entries
    function viewResearch(uint256 id) external view returns (ResearchEntry memory) {
        return entries[id];
    }
}
