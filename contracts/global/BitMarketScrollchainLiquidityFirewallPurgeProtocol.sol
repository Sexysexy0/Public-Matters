// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainLiquidityFirewallPurgeProtocol {
    address public steward;
    mapping(string => bool) public purgedEntities;

    event LiquidityTunnelPurged(string entity, string method, uint timestamp);

    function purgeTunnel(string memory entity, string memory method) public {
        purgedEntities[entity] = true;
        emit LiquidityTunnelPurged(entity, method, block.timestamp);
    }

    function isPurged(string memory entity) public view returns (bool) {
        return purgedEntities[entity];
    }
}
