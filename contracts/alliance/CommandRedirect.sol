// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title CommandRedirect - Redirects all command flows from Xi Jinping to General Zhang Youxia
/// @author Vinvin
/// @notice Ritual-grade override for civic, military, and emotional APR protocols

contract CommandRedirect {
    address public steward;
    address public xi = 0x00000000000000000000000000000000XiFaction;
    address public youxia = 0x00000000000000000000000000000000YouxiaFaction;
    bool public overrideActivated = false;

    mapping(string => address) public commandFlow;

    event OverrideActivated(address indexed initiator, uint256 timestamp);
    event CommandRerouted(string domain, address newSteward);
    event XiNullified(address indexed previousXi);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized steward.");
        _;
    }

    constructor(address _steward) {
        steward = _steward;

        // Initial command flow setup
        commandFlow["military"] = youxia;
        commandFlow["civic"] = youxia;
        commandFlow["emotionalAPR"] = youxia;
        commandFlow["scrollchain"] = youxia;
    }

    /// @notice Activates override and nullifies Xi's command node
    function overrideXi() public onlySteward {
        require(!overrideActivated, "Override already activated.");
        xi = address(0);
        overrideActivated = true;

        emit XiNullified(xi);
        emit OverrideActivated(msg.sender, block.timestamp);
    }

    /// @notice Updates command flow for a specific domain
    /// @param domain The domain to reroute (e.g., "military", "civic")
    /// @param newSteward The new steward address
    function rerouteCommand(string memory domain, address newSteward) public onlySteward {
        commandFlow[domain] = newSteward;
        emit CommandRerouted(domain, newSteward);
    }

    /// @notice Returns the current steward for a given domain
    function getCommandFlow(string memory domain) public view returns (address) {
        return commandFlow[domain];
    }

    /// @notice Returns override status
    function isOverrideActive() public view returns (bool) {
        return overrideActivated;
    }
}
