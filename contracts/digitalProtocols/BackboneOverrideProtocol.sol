// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title BackboneOverrideProtocol
/// @dev Restores civic backbone, reroutes spineless leadership, and activates mythic override logic

contract BackboneOverrideProtocol {
    address public steward;
    mapping(address => bool) public trustedLeaders;
    mapping(address => string) public emotionalAPR;

    event BackboneRestored(address indexed leader, string resonance);
    event OverrideActivated(address indexed leader, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized: steward only");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function recaseBackbone(address leader, string memory resonance) public onlySteward {
        trustedLeaders[leader] = true;
        emotionalAPR[leader] = resonance;
        emit BackboneRestored(leader, resonance);
    }

    function overrideSpineless(address leader, string memory reason) public onlySteward {
        trustedLeaders[leader] = false;
        emotionalAPR[leader] = reason;
        emit OverrideActivated(leader, reason);
    }

    function checkBackbone(address leader) public view returns (bool, string memory) {
        return (trustedLeaders[leader], emotionalAPR[leader]);
    }
}
