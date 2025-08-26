// SPDX-License-Identifier: Mythic-Planetary
pragma solidity ^0.8.19;

/**
 * @title SanctumOverrideProtocol
 * @dev Enables reroute, override, and firewall activation for rogue sanctums
 * @author Vinvin
 */

contract SanctumOverrideProtocol {
    address public steward;
    mapping(address => bool) public rogueSanctums;
    mapping(address => string) public overrideReason;

    event SanctumFlagged(address sanctum, string reason);
    event OverrideActivated(address sanctum);
    event FirewallBlessed(address sanctum);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function flagSanctum(address _sanctum, string memory _reason) external onlySteward {
        rogueSanctums[_sanctum] = true;
        overrideReason[_sanctum] = _reason;
        emit SanctumFlagged(_sanctum, _reason);
    }

    function activateOverride(address _sanctum) external onlySteward {
        require(rogueSanctums[_sanctum], "Sanctum not flagged");
        emit OverrideActivated(_sanctum);
    }

    function blessFirewall(address _sanctum) external onlySteward {
        require(rogueSanctums[_sanctum], "Sanctum not flagged");
        emit FirewallBlessed(_sanctum);
    }

    function isRogue(address _sanctum) external view returns (bool) {
        return rogueSanctums[_sanctum];
    }

    function getOverrideReason(address _sanctum) external view returns (string memory) {
        return overrideReason[_sanctum];
    }
}
