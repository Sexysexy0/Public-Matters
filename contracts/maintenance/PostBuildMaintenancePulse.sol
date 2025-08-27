// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract PostBuildMaintenancePulse {
    address public steward;

    struct MaintenanceLog {
        string projectName;
        string issue;
        uint256 timestamp;
        bool resolved;
        string resolutionNotes;
    }

    MaintenanceLog[] public logs;

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized maintenance ritual.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function reportIssue(string memory projectName, string memory issue) public onlySteward {
        logs.push(MaintenanceLog({
            projectName: projectName,
            issue: issue,
            timestamp: block.timestamp,
            resolved: false,
            resolutionNotes: ""
        }));
    }

    function resolveIssue(uint256 index, string memory notes) public onlySteward {
        require(index < logs.length, "Invalid log index.");
        logs[index].resolved = true;
        logs[index].resolutionNotes = notes;
    }

    function auditLog(uint256 index) public view returns (string memory) {
        MaintenanceLog memory m = logs[index];
        return string(abi.encodePacked(
            "Project: ", m.projectName,
            " | Issue: ", m.issue,
            " | Timestamp: ", uint2str(m.timestamp),
            " | Resolved: ", m.resolved ? "Yes" : "No",
            " | Notes: ", m.resolutionNotes
        ));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) { len++; j /= 10; }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k--;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
