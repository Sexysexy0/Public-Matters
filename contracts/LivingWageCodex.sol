// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LivingWageCodex
/// @notice Codex covenant to enforce minimum living wage standards
contract LivingWageCodex {
    address public overseer;
    uint256 public codexCount;
    uint256 public minimumWage; // living wage threshold

    struct WageRecord {
        uint256 id;
        string institution;   // company or organization name
        uint256 wage;         // actual wage paid
        bool compliant;       // true if >= minimumWage
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => WageRecord) public records;

    event WageLogged(uint256 indexed id, string institution, uint256 wage, bool compliant, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer, uint256 _minimumWage) {
        overseer = _overseer;
        minimumWage = _minimumWage;
    }

    /// @notice Overseer logs wage compliance record
    function logWage(string calldata institution, uint256 wage, string calldata notes) external onlyOverseer {
        codexCount++;
        bool compliant = wage >= minimumWage;
        records[codexCount] = WageRecord({
            id: codexCount,
            institution: institution,
            wage: wage,
            compliant: compliant,
            notes: notes,
            timestamp: block.timestamp
        });
        emit WageLogged(codexCount, institution, wage, compliant, notes);
    }

    /// @notice Citizens can view wage compliance records
    function viewWage(uint256 id) external view returns (WageRecord memory) {
        return records[id];
    }

    /// @notice Overseer can update minimum wage threshold
    function updateMinimumWage(uint256 newWage) external onlyOverseer {
        minimumWage = newWage;
    }
}
