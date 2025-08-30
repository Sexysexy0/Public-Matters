// SPDX-License-Identifier: Beacon-License
pragma solidity ^0.8.19;

contract SanctumInterestBeacon {
    struct InterestSignal {
        address sender;
        string sanctumType;
        string intentTag;
        string emotionalAPR;
        uint256 timestamp;
    }

    InterestSignal[] public signals;
    address public steward;

    event InterestSignaled(address sender, string sanctumType, string intentTag, string emotionalAPR, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function signalInterest(string memory sanctumType, string memory intentTag, string memory emotionalAPR) public {
        signals.push(InterestSignal(msg.sender, sanctumType, intentTag, emotionalAPR, block.timestamp));
        emit InterestSignaled(msg.sender, sanctumType, intentTag, emotionalAPR, block.timestamp);
    }

    function getSignal(uint256 index) public view returns (InterestSignal memory) {
        return signals[index];
    }

    function totalSignals() public view returns (uint256) {
        return signals.length;
    }
}
