// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract RogueFlagOverride {
    address public steward;

    mapping(address => bool) public overrideApproved;
    mapping(address => string) public overrideReason;
    mapping(address => uint256) public overrideTimestamp;

    event OverrideRequested(address contractor, string reason);
    event OverrideApproved(address contractor, string reason, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function requestOverride(address contractor, string memory reason) public onlySteward {
        overrideReason[contractor] = reason;
        emit OverrideRequested(contractor, reason);
    }

    function approveOverride(address contractor) public onlySteward {
        require(bytes(overrideReason[contractor]).length > 0, "No override requested");
        overrideApproved[contractor] = true;
        overrideTimestamp[contractor] = block.timestamp;
        emit OverrideApproved(contractor, overrideReason[contractor], block.timestamp);
    }

    function isOverrideApproved(address contractor) public view returns (bool) {
        return overrideApproved[contractor];
    }

    function getOverrideDetails(address contractor) public view returns (string memory reason, uint256 timestamp) {
        return (overrideReason[contractor], overrideTimestamp[contractor]);
    }
}
