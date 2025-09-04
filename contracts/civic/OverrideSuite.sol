// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract OverrideSuite {
    struct OverrideRequest {
        address steward;
        string reason;
        bool approved;
    }

    mapping(uint256 => OverrideRequest) public requests;
    uint256 public requestCount;

    event OverrideRequested(uint256 indexed id, address steward, string reason);
    event OverrideApproved(uint256 indexed id);

    function requestOverride(string memory _reason) external {
        requests[requestCount] = OverrideRequest(msg.sender, _reason, false);
        emit OverrideRequested(requestCount, msg.sender, _reason);
        requestCount++;
    }

    function approveOverride(uint256 _id) external {
        require(!requests[_id].approved, "Already approved");
        requests[_id].approved = true;
        emit OverrideApproved(_id);
    }

    function auditOverride(uint256 _id) external view returns (OverrideRequest memory) {
        return requests[_id];
    }
}
