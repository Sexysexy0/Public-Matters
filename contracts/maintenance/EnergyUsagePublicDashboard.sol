// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EnergyUsagePublicDashboard
 * @notice Read‑only public ledger interface for live viewing of DC usage, levies, and compliance.
 */
contract EnergyUsagePublicDashboard {
    struct Record {
        string name;
        uint256 totalKWh;
        uint256 totalLevy;
        bool compliant;
    }

    mapping(address => Record) public records;
    event RecordUpdated(address dc, uint256 totalKWh, uint256 totalLevy, bool compliant);

    function updateRecord(address dc, string calldata name, uint256 kWh, uint256 levy, bool comp) external {
        records[dc] = Record(name, kWh, levy, comp);
        emit RecordUpdated(dc, kWh, levy, comp);
    }

    function getRecord(address dc) external view returns (Record memory) {
        return records[dc];
    }
}
