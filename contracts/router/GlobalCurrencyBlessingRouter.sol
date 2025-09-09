// SPDX-License-Identifier: GlobalCurrencyBlessing-License
pragma solidity ^0.8.0;

contract GlobalCurrencyBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string currency;
        string region;
        bool blessingConfirmed;
        string anchorType;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event CurrencyBlessingRouted(string currency, string region, bool blessingConfirmed, string anchorType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory currency, string memory region, bool blessingConfirmed, string memory anchorType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(currency, region, blessingConfirmed, anchorType, block.timestamp));
        emit CurrencyBlessingRouted(currency, region, blessingConfirmed, anchorType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.currency, s.region, s.blessingConfirmed, s.anchorType, s.timestamp);
    }
}
