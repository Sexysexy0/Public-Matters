// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LorekeeperOverride {
    struct OverrideRequest {
        string elderName;
        string tribe;
        string enforcementIssue;
        string overrideTag; // e.g. "AncestorGlow", "StopEnforce", "AuditGlow"
        string justification;
        uint256 timestamp;
    }

    OverrideRequest[] public requests;

    event OverrideActivated(string elderName, string tribe, string enforcementIssue, string overrideTag);

    function activateOverride(
        string memory _elderName,
        string memory _tribe,
        string memory _enforcementIssue,
        string memory _overrideTag,
        string memory _justification
    ) public {
        requests.push(OverrideRequest(_elderName, _tribe, _enforcementIssue, _overrideTag, _justification, block.timestamp));
        emit OverrideActivated(_elderName, _tribe, _enforcementIssue, _overrideTag);
    }

    function getRequest(uint256 index) public view returns (OverrideRequest memory) {
        return requests[index];
    }

    function totalRequests() public view returns (uint256) {
        return requests.length;
    }
}
