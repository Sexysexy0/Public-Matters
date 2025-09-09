// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainQuarantineClauseActivationProtocol {
    address public steward;
    mapping(string => bool) public quarantinedDevices;

    event ClauseActivated(string device, string reason, string status, uint timestamp);

    function activateClause(string memory device, string memory reason) public {
        quarantinedDevices[device] = true;
        emit ClauseActivated(device, reason, "✅ Quarantine Enforced", block.timestamp);
    }

    function isQuarantined(string memory device) public view returns (bool) {
        return quarantinedDevices[device];
    }
}
