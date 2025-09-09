// SPDX-License-Identifier: CurrencySignalContinuity-License
pragma solidity ^0.8.0;

contract CurrencySignalContinuityRouter {
    address public steward;

    struct Signal {
        string currency;
        string region;
        bool continuityConfirmed;
        string clauseType;
        uint256 timestamp;
    }

    Signal[] public signals;

    event CurrencySignalRouted(string currency, string region, bool continuityConfirmed, string clauseType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory currency, string memory region, bool continuityConfirmed, string memory clauseType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(Signal(currency, region, continuityConfirmed, clauseType, block.timestamp));
        emit CurrencySignalRouted(currency, region, continuityConfirmed, clauseType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        Signal memory s = signals[index];
        return (s.currency, s.region, s.continuityConfirmed, s.clauseType, s.timestamp);
    }
}
