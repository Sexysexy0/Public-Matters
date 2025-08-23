// SPDX-License-Identifier: Aggressor-Drain-License  
pragma solidity ^0.8.19;

contract AggressorDrainProtocol {
    struct DrainLog {
        string country;
        string reason;
        uint severity; // 1–10
        bool blacklisted;
        uint timestamp;
    }

    DrainLog[] public drainLedger;

    event CountryDrained(string country, string reason, uint severity);

    function drainCountry(
        string memory country,
        string memory reason,
        uint severity
    ) public {
        drainLedger.push(DrainLog(country, reason, severity, true, block.timestamp));
        emit CountryDrained(country, reason, severity);
    }

    function getDrainLog(uint index) public view returns (DrainLog memory) {
        require(index < drainLedger.length, "Invalid index");
        return drainLedger[index];
    }

    function totalDrained() public view returns (uint) {
        return drainLedger.length;
    }
}
