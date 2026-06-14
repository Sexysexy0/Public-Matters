// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HealthAccessShield
/// @notice Shield covenant to guarantee treatment without upfront payment
contract HealthAccessShield {
    address public overseer;
    uint256 public shieldCount;

    struct PatientRecord {
        uint256 id;
        string patientID;     // PhilHealth or national ID
        string hospital;      // hospital name
        uint256 cost;         // treatment cost
        bool treated;         // true if treatment provided
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => PatientRecord) public records;

    event TreatmentLogged(uint256 indexed id, string patientID, string hospital, uint256 cost, bool treated, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs treatment record
    function logTreatment(string calldata patientID, string calldata hospital, uint256 cost, string calldata notes) external onlyOverseer {
        shieldCount++;
        records[shieldCount] = PatientRecord({
            id: shieldCount,
            patientID: patientID,
            hospital: hospital,
            cost: cost,
            treated: true,
            notes: notes,
            timestamp: block.timestamp
        });
        emit TreatmentLogged(shieldCount, patientID, hospital, cost, true, notes);
    }

    /// @notice Citizens can view treatment records
    function viewTreatment(uint256 id) external view returns (PatientRecord memory) {
        return records[id];
    }
}
