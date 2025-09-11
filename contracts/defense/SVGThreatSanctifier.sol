// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SVGThreatSanctifier {
    struct SVGThreat {
        string fileHash;
        string originDomain;
        string embeddedScriptSummary;
        uint256 timestamp;
        bool impersonatesGovernment;
        bool confirmedMalicious;
    }

    mapping(uint256 => SVGThreat) public threatLedger;
    uint256 public threatCount;

    event ThreatSanctified(uint256 id, string fileHash, string originDomain);

    function logThreat(
        string memory fileHash,
        string memory originDomain,
        string memory embeddedScriptSummary,
        uint256 timestamp,
        bool impersonatesGovernment
    ) public {
        threatLedger[threatCount] = SVGThreat(
            fileHash,
            originDomain,
            embeddedScriptSummary,
            timestamp,
            impersonatesGovernment,
            false
        );
        emit ThreatSanctified(threatCount, fileHash, originDomain);
        threatCount++;
    }

    function confirmMalicious(uint256 id) public {
        threatLedger[id].confirmedMalicious = true;
    }

    function getThreat(uint256 id) public view returns (SVGThreat memory) {
        return threatLedger[id];
    }
}
