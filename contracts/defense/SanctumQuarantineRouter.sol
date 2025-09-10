// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SanctumQuarantineRouter {
    event Quarantined(address node, string reason, uint256 timestamp);
    event Restored(address node, string blessing, uint256 timestamp);

    mapping(address => bool) public quarantined;

    function quarantine(address node, string memory reason) public {
        quarantined[node] = true;
        emit Quarantined(node, reason, block.timestamp);
    }

    function restore(address node, string memory blessing) public {
        require(quarantined[node], "Node not quarantined");
        quarantined[node] = false;
        emit Restored(node, blessing, block.timestamp);
    }

    function isQuarantined(address node) public view returns (bool) {
        return quarantined[node];
    }
}
