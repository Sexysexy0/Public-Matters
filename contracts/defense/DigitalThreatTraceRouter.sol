// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DigitalThreatTraceRouter {
    struct ThreatSignal {
        string platform;
        string message;
        uint256 timestamp;
        string originHandle;
        string geoTag;
        bool validated;
    }

    mapping(uint256 => ThreatSignal) public threatLedger;
    uint256 public threatCount;

    event ThreatLogged(uint256 id, string platform, string originHandle);

    function logThreat(
        string memory platform,
        string memory message,
        uint256 timestamp,
        string memory originHandle,
        string memory geoTag
    ) public {
        threatLedger[threatCount] = ThreatSignal(
            platform,
            message,
            timestamp,
            originHandle,
            geoTag,
            false
        );
        emit ThreatLogged(threatCount, platform, originHandle);
        threatCount++;
    }

    function validateThreat(uint256 id) public {
        threatLedger[id].validated = true;
    }

    function getThreat(uint256 id) public view returns (ThreatSignal memory) {
        return threatLedger[id];
    }
}
