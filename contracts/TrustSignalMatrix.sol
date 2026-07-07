// SPDX-License-Identifier: MIT
// Contract Name: TrustSignalMatrix
// Purpose: Establish trust signals in governance interactions
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract TrustSignalMatrix {
    address public chiefOperator;
    uint256 public matrixCount;

    struct Signal {
        string principle;
        string trustMechanism;
        uint256 timestamp;
    }

    Signal[] public signals;

    event SignalAdded(string principle, string trustMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        matrixCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new trust signal clause
    function addSignal(string memory principle, string memory trustMechanism) public onlyChief {
        signals.push(Signal(principle, trustMechanism, block.timestamp));
        matrixCount++;
        emit SignalAdded(principle, trustMechanism, block.timestamp);
    }

    // View trust signal details
    function getSignal(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < signals.length, "Invalid signal index");
        Signal memory s = signals[index];
        return (s.principle, s.trustMechanism, s.timestamp);
    }
}
