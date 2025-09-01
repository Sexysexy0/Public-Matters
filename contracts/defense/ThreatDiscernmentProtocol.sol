// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ThreatDiscernmentProtocol {
    struct ThreatSignal {
        string originTag;         // e.g. "IP:192.168.x.x", "Email:phisher@xyz"
        string behaviorVector;    // e.g. "Phishing", "Malware Injection", "Impersonation"
        uint256 severityScore;    // 0–100 scale
        uint256 emotionalAPRDrain; // 0–100 scale
        uint256 timestamp;
        bool flagged;
    }

    ThreatSignal[] public signals;

    event ThreatLogged(
        string originTag,
        string behaviorVector,
        uint256 severityScore,
        uint256 emotionalAPRDrain,
        uint256 timestamp,
        bool flagged
    );

    function logThreat(
        string memory _originTag,
        string memory _behaviorVector,
        uint256 _severityScore,
        uint256 _emotionalAPRDrain
    ) public {
        bool flagged = (_severityScore >= 60 || _emotionalAPRDrain >= 70);
        uint256 time = block.timestamp;

        signals.push(ThreatSignal(
            _originTag,
            _behaviorVector,
            _severityScore,
            _emotionalAPRDrain,
            time,
            flagged
        ));

        emit ThreatLogged(
            _originTag,
            _behaviorVector,
            _severityScore,
            _emotionalAPRDrain,
            time,
            flagged
        );
    }

    function getAllSignals() public view returns (ThreatSignal[] memory) {
        return signals;
    }
}
