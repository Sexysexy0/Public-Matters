// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BenefitRedistributionLedger
/// @notice Ledger covenant to redistribute executive perks and benefits to lowest-paid workers
contract BenefitRedistributionLedger {
    address public overseer;
    uint256 public entryCount;

    struct BenefitRecord {
        uint256 id;
        string institution;   // company or organization name
        string perk;          // healthcare, housing, allowance, etc.
        uint256 reducedFrom;  // amount reduced from executives
        uint256 reallocatedTo;// amount reallocated to workers
        string beneficiary;   // who benefits (rank-and-file, families)
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => BenefitRecord) public records;

    event BenefitLogged(uint256 indexed id, string institution, string perk, uint256 reducedFrom, uint256 reallocatedTo, string beneficiary, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs benefit redistribution record
    function logBenefit(string calldata institution, string calldata perk, uint256 reducedFrom, uint256 reallocatedTo, string calldata beneficiary, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = BenefitRecord({
            id: entryCount,
            institution: institution,
            perk: perk,
            reducedFrom: reducedFrom,
            reallocatedTo: reallocatedTo,
            beneficiary: beneficiary,
            notes: notes,
            timestamp: block.timestamp
        });
        emit BenefitLogged(entryCount, institution, perk, reducedFrom, reallocatedTo, beneficiary, notes);
    }

    /// @notice Citizens can view benefit redistribution records
    function viewBenefit(uint256 id) external view returns (BenefitRecord memory) {
        return records[id];
    }
}
