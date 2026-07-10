// SPDX-License-Identifier: MIT
// Contract Name: TrustSignalMatrix
// Purpose: Encode trust indicators for governance decisions
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract TrustSignalMatrix {
    address public chiefOperator;
    uint256 public signalCount;

    struct Signal {
        string domain;          // e.g., Finance, Workforce, Community
        string indicator;       // e.g., Transparency, Fairness, Accountability
        string verification;    // e.g., Audit, Public log, Peer review
        uint256 timestamp;
    }

    Signal[] public signals;

    event SignalAdded(string domain, string indicator, string verification, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        signalCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new trust signal
    function addSignal(string memory domain, string memory indicator, string memory verification) public onlyChief {
        signals.push(Signal(domain, indicator, verification, block.timestamp));
        signalCount++;
        emit SignalAdded(domain, indicator, verification, block.timestamp);
    }

    // View trust signal details
    function getSignal(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < signals.length, "Invalid signal index");
        Signal memory s = signals[index];
        return (s.domain, s.indicator, s.verification, s.timestamp);
    }
}
