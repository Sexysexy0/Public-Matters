// SPDX-License-Identifier: SentimentFirewallRouter-License
pragma solidity ^0.8.0;

contract SentimentFirewallRouter {
    address public steward;

    struct SignalRoute {
        string signalType;
        string originZone;
        string filterApplied;
        bool routedSuccessfully;
        uint256 timestamp;
    }

    SignalRoute[] public routes;

    event SignalRouted(string signalType, string originZone, string filterApplied, bool routedSuccessfully, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory signalType, string memory originZone, string memory filterApplied, bool routedSuccessfully) public {
        require(msg.sender == steward, "Only steward can route");
        routes.push(SignalRoute(signalType, originZone, filterApplied, routedSuccessfully, block.timestamp));
        emit SignalRouted(signalType, originZone, filterApplied, routedSuccessfully, block.timestamp);
    }

    function getRoute(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        SignalRoute memory r = routes[index];
        return (r.signalType, r.originZone, r.filterApplied, r.routedSuccessfully, r.timestamp);
    }
}
