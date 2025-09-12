// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DevToolBlessingFirewall {
    enum BlessingStatus { Unverified, Blessed, Banned, Restricted }

    struct DevTool {
        string name;
        string origin;
        string usageContext;
        BlessingStatus status;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => DevTool) public toolRegistry;
    uint256 public toolCount;

    event ToolTagged(uint256 id, string name, BlessingStatus status);

    function tagTool(
        string memory name,
        string memory origin,
        string memory usageContext,
        BlessingStatus status,
        string memory reason,
        uint256 timestamp
    ) public {
        toolRegistry[toolCount] = DevTool(
            name,
            origin,
            usageContext,
            status,
            reason,
            timestamp
        );
        emit ToolTagged(toolCount, name, status);
        toolCount++;
    }

    function getTool(uint256 id) public view returns (DevTool memory) {
        return toolRegistry[id];
    }

    function blessTool(uint256 id) public {
        toolRegistry[id].status = BlessingStatus.Blessed;
    }

    function banTool(uint256 id) public {
        toolRegistry[id].status = BlessingStatus.Banned;
    }

    function restrictTool(uint256 id) public {
        toolRegistry[id].status = BlessingStatus.Restricted;
    }
}
