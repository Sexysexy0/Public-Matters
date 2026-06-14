// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TruthValidationLedger
/// @notice Ledger covenant to encode institutional validation of whistleblower claims
contract TruthValidationLedger {
    address public overseer;
    uint256 public entryCount;

    struct ValidationRecord {
        uint256 id;
        string institution; // Senate, oversight body
        string finding;     // torture confirmed, no actionable intelligence
        string consequence; // validation, accountability gap
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ValidationRecord) public records;

    event ValidationLogged(uint256 indexed id, string institution, string finding, string consequence);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs truth validation record
    function logValidation(string calldata institution, string calldata finding, string calldata consequence, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = ValidationRecord({
            id: entryCount,
            institution: institution,
            finding: finding,
            consequence: consequence,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ValidationLogged(entryCount, institution, finding, consequence);
    }

    /// @notice Citizens can view truth validation records
    function viewValidation(uint256 id) external view returns (ValidationRecord memory) {
        return records[id];
    }
}
