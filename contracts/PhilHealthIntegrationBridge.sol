// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PhilHealthIntegrationBridge
/// @notice Bridge covenant to integrate PhilHealth ID with healthcare deductions and savings split
contract PhilHealthIntegrationBridge {
    address public overseer;
    uint256 public bridgeCount;

    struct HealthRecord {
        uint256 id;
        string patientID;     // PhilHealth or national ID
        uint256 contribution; // total contribution made
        uint256 expense;      // hospital expense deducted
        uint256 savings;      // emergency savings retained
        string hospital;      // hospital name
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => HealthRecord) public records;

    event HealthLogged(uint256 indexed id, string patientID, uint256 contribution, uint256 expense, uint256 savings, string hospital, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs healthcare deduction and savings split
    function logHealth(string calldata patientID, uint256 contribution, uint256 expense, uint256 savings, string calldata hospital, string calldata notes) external onlyOverseer {
        require(expense + savings <= contribution, "Invalid split");
        bridgeCount++;
        records[bridgeCount] = HealthRecord({
            id: bridgeCount,
            patientID: patientID,
            contribution: contribution,
            expense: expense,
            savings: savings,
            hospital: hospital,
            notes: notes,
            timestamp: block.timestamp
        });
        emit HealthLogged(bridgeCount, patientID, contribution, expense, savings, hospital, notes);
    }

    /// @notice Citizens can view healthcare records
    function viewHealth(uint256 id) external view returns (HealthRecord memory) {
        return records[id];
    }
}
