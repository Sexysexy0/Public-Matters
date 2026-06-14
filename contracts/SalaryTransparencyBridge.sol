// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SalaryTransparencyBridge
/// @notice Bridge covenant to publish salary bands and pay ratios for payroll equity
contract SalaryTransparencyBridge {
    address public overseer;
    uint256 public bridgeCount;

    struct SalaryRecord {
        uint256 id;
        string institution;   // company or organization name
        uint256 topSalary;    // highest salary in band
        uint256 lowestSalary; // lowest salary in band
        uint256 ratio;        // pay ratio (top/lowest)
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => SalaryRecord) public records;

    event SalaryLogged(uint256 indexed id, string institution, uint256 topSalary, uint256 lowestSalary, uint256 ratio, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs salary transparency record
    function logSalary(string calldata institution, uint256 topSalary, uint256 lowestSalary, string calldata notes) external onlyOverseer {
        bridgeCount++;
        uint256 ratio = lowestSalary > 0 ? topSalary * 100 / lowestSalary : 0;
        records[bridgeCount] = SalaryRecord({
            id: bridgeCount,
            institution: institution,
            topSalary: topSalary,
            lowestSalary: lowestSalary,
            ratio: ratio,
            notes: notes,
            timestamp: block.timestamp
        });
        emit SalaryLogged(bridgeCount, institution, topSalary, lowestSalary, ratio, notes);
    }

    /// @notice Citizens can view salary transparency records
    function viewSalary(uint256 id) external view returns (SalaryRecord memory) {
        return records[id];
    }
}
