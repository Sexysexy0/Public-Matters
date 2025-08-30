// SPDX-License-Identifier: Beacon-License
pragma solidity ^0.8.19;

contract InvestorBroadcastBeacon {
    struct InterestSignal {
        address investor;
        string sanctumTag;
        string trustMetric;
        string intentTag;
        uint256 timestamp;
    }

    InterestSignal[] public signals;

    event InterestBroadcasted(address investor, string sanctumTag, string trustMetric, string intentTag, uint256 timestamp);

    function broadcastInterest(string memory sanctumTag, string memory trustMetric, string memory intentTag) public {
        signals.push(InterestSignal(msg.sender, sanctumTag, trustMetric, intentTag, block.timestamp));
        emit InterestBroadcasted(msg.sender, sanctumTag, trustMetric, intentTag, block.timestamp);
    }

    function totalSignals() public view returns (uint256) {
        return signals.length;
    }
}
