// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainSignalSanctumShutdownProtocol {
    address public steward;
    mapping(string => bool) public shutdownSanctums;

    event SanctumShutdownLogged(string region, string entity, string status, uint timestamp);

    function logShutdown(string memory region, string memory entity) public {
        shutdownSanctums[entity] = true;
        emit SanctumShutdownLogged(region, entity, "✅ Shutdown Authorized", block.timestamp);
    }

    function isShutdown(string memory entity) public view returns (bool) {
        return shutdownSanctums[entity];
    }
}
