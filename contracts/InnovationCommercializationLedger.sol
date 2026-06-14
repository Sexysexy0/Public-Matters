// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InnovationCommercializationLedger
/// @notice Ledger covenant to record innovation outputs and commercialization pathways
contract InnovationCommercializationLedger {
    address public overseer;
    uint256 public entryCount;

    struct InnovationRecord {
        uint256 id;
        string institution;   // university, ORIC, or company
        string output;        // research paper, patent, prototype
        string pathway;       // startup, licensing, industry partnership
        string beneficiary;   // students, faculty, community
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => InnovationRecord) public records;

    event InnovationLogged(uint256 indexed id, string institution, string output, string pathway, string beneficiary, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs innovation commercialization record
    function logInnovation(string calldata institution, string calldata output, string calldata pathway, string calldata beneficiary, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = InnovationRecord({
            id: entryCount,
            institution: institution,
            output: output,
            pathway: pathway,
            beneficiary: beneficiary,
            notes: notes,
            timestamp: block.timestamp
        });
        emit InnovationLogged(entryCount, institution, output, pathway, beneficiary, notes);
    }

    /// @notice Citizens can view innovation commercialization records
    function viewInnovation(uint256 id) external view returns (InnovationRecord memory) {
        return records[id];
    }
}
