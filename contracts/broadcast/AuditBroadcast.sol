// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AuditBroadcast {
    struct BroadcastLog {
        uint256 sanctumId;
        string region;
        string stewardTag;
        string auditStatus; // e.g. "Blessed", "Pending", "Damay Activated"
        string message;
        uint256 timestamp;
    }

    BroadcastLog[] public logs;
    address public broadcaster;

    event AuditBroadcasted(uint256 sanctumId, string region, string auditStatus);

    modifier onlyBroadcaster() {
        require(msg.sender == broadcaster, "Unauthorized audit broadcaster");
        _;
    }

    constructor() {
        broadcaster = msg.sender;
    }

    function broadcastAudit(
        uint256 _sanctumId,
        string memory _region,
        string memory _stewardTag,
        string memory _auditStatus,
        string memory _message
    ) external onlyBroadcaster {
        logs.push(BroadcastLog(_sanctumId, _region, _stewardTag, _auditStatus, _message, block.timestamp));
        emit AuditBroadcasted(_sanctumId, _region, _auditStatus);
    }

    function getBroadcast(uint256 _id) external view returns (BroadcastLog memory) {
        return logs[_id];
    }

    function totalBroadcasts() external view returns (uint256) {
        return logs.length;
    }
}
