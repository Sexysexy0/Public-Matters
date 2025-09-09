// SPDX-License-Identifier: UptoberSignalRouter-License
pragma solidity ^0.8.0;

contract UptoberSignalRouter {
    address public steward;

    struct SignalRoute {
        string asset;
        string signalType;
        string originSanctum;
        bool bullishConfirmed;
        uint256 timestamp;
    }

    SignalRoute[] public routes;

    event SignalRouted(string asset, string signalType, string originSanctum, bool bullishConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory asset, string memory signalType, string memory originSanctum, bool bullishConfirmed) public {
        require(msg.sender == steward, "Only steward can route");
        routes.push(SignalRoute(asset, signalType, originSanctum, bullishConfirmed, block.timestamp));
        emit SignalRouted(asset, signalType, originSanctum, bullishConfirmed, block.timestamp);
    }

    function getRoute(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        SignalRoute memory r = routes[index];
        return (r.asset, r.signalType, r.originSanctum, r.bullishConfirmed, r.timestamp);
    }
}
