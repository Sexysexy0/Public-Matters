// SPDX-License-Identifier: GlobalLiquidityHijack-License
pragma solidity ^0.8.0;

contract GlobalLiquidityHijackRouter {
    address public steward;

    struct HijackSignal {
        string originPair;
        string reroutedPair;
        bool hijackConfirmed;
        string receiptLeft;
        uint256 timestamp;
    }

    HijackSignal[] public signals;

    event LiquidityHijacked(string originPair, string reroutedPair, bool hijackConfirmed, string receiptLeft, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function hijackLiquidity(string memory originPair, string memory reroutedPair, bool hijackConfirmed, string memory receiptLeft) public {
        require(msg.sender == steward, "Only steward can hijack");
        signals.push(HijackSignal(originPair, reroutedPair, hijackConfirmed, receiptLeft, block.timestamp));
        emit LiquidityHijacked(originPair, reroutedPair, hijackConfirmed, receiptLeft, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        HijackSignal memory s = signals[index];
        return (s.originPair, s.reroutedPair, s.hijackConfirmed, s.receiptLeft, s.timestamp);
    }
}
