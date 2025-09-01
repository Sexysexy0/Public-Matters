// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CyberDefenseScroll {
    struct ThreatReport {
        string source;
        string vector;
        uint256 severity;
        uint256 emotionalAPR;
        uint256 timestamp;
        bool neutralized;
    }

    ThreatReport[] public reports;

    event ThreatLogged(
        string source,
        string vector,
        uint256 severity,
        uint256 emotionalAPR,
        uint256 timestamp,
        bool neutralized
    );

    function logThreat(
        string memory _source,
        string memory _vector,
        uint256 _severity,
        uint256 _emotionalAPR
    ) public {
        bool neutralized = (_severity < 50 && _emotionalAPR >= 80);
        uint256 time = block.timestamp;

        reports.push(ThreatReport(_source, _vector, _severity, _emotionalAPR, time, neutralized));
        emit ThreatLogged(_source, _vector, _severity, _emotionalAPR, time, neutralized);
    }

    function getAllReports() public view returns (ThreatReport[] memory) {
        return reports;
    }
}
