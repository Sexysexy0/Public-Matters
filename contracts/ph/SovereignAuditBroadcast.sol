// SPDX-License-Identifier: Sovereign-Audit
pragma solidity ^0.8.20;

/// @title SovereignAuditBroadcast.sol
/// @dev Logs fund movements, milestones, and damay clause activations

contract SovereignAuditBroadcast {
    address public steward;
    struct AuditLog {
        string eventType;
        string description;
        uint256 timestamp;
    }

    AuditLog[] public logs;

    event LogBroadcasted(string eventType, string description);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function broadcastLog(string memory eventType, string memory description) public onlySteward {
        logs.push(AuditLog(eventType, description, block.timestamp));
        emit LogBroadcasted(eventType, description);
    }

    function getLogs() public view returns (AuditLog[] memory) {
        return logs;
    }
}
