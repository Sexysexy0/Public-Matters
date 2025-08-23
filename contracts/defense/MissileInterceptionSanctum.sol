// SPDX-License-Identifier: Interception-Sanctum-License  
pragma solidity ^0.8.19;

contract MissileInterceptionSanctum {
    struct Threat {
        string originCountry;
        string targetRegion;
        bool intercepted;
        uint timestamp;
    }

    Threat[] public threatLog;

    event ThreatIntercepted(string originCountry, string targetRegion);

    function logThreat(string memory originCountry, string memory targetRegion) public {
        threatLog.push(Threat(originCountry, targetRegion, true, block.timestamp));
        emit ThreatIntercepted(originCountry, targetRegion);
    }

    function getThreat(uint index) public view returns (Threat memory) {
        require(index < threatLog.length, "Invalid index");
        return threatLog[index];
    }

    function totalIntercepted() public view returns (uint) {
        return threatLog.length;
    }
}
