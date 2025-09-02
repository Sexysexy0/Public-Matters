// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DebtToGDPOverride {
    struct GDPRecord {
        uint256 debt;
        uint256 gdp;
        bool overrideTriggered;
        string reason;
    }

    mapping(uint256 => GDPRecord) public records;
    uint256 public recordCounter;
    event PardonActivated(uint256 indexed recordId, string reason);

    function logGDP(uint256 debt, uint256 gdp, string memory reason) public {
        bool trigger = (debt * 100 / gdp) > 60; // Example threshold
        records[recordCounter] = GDPRecord(debt, gdp, trigger, reason);
        if (trigger) {
            emit PardonActivated(recordCounter, reason);
        }
        recordCounter++;
    }

    function getDebtToGDP(uint256 recordId) public view returns (uint256) {
        GDPRecord memory r = records[recordId];
        return r.debt * 100 / r.gdp;
    }
}
