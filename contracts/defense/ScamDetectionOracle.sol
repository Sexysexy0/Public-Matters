// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ScamDetectionOracle {
    struct ScamSignal {
        string origin;
        string method;
        string impersonationLevel;
        uint256 emotionalAPRDrain;
        uint256 timestamp;
        bool flagged;
    }

    ScamSignal[] public signals;

    event ScamDetected(
        string origin,
        string method,
        string impersonationLevel,
        uint256 emotionalAPRDrain,
        uint256 timestamp,
        bool flagged
    );

    function detectScam(
        string memory _origin,
        string memory _method,
        string memory _impersonationLevel,
        uint256 _emotionalAPRDrain
    ) public {
        bool flagged = (_emotionalAPRDrain > 60 || keccak256(bytes(_impersonationLevel)) == keccak256("High"));
        uint256 time = block.timestamp;

        signals.push(ScamSignal(_origin, _method, _impersonationLevel, _emotionalAPRDrain, time, flagged));
        emit ScamDetected(_origin, _method, _impersonationLevel, _emotionalAPRDrain, time, flagged);
    }

    function getAllSignals() public view returns (ScamSignal[] memory) {
        return signals;
    }
}
