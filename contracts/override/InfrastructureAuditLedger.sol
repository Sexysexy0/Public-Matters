// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract InfrastructureAuditLedger {
    address public steward;

    struct Project {
        string name;
        uint256 budget;
        uint256 timestamp;
        uint256 corruptionScore;
        bool isFlagged;
    }

    mapping(uint256 => Project) public projects;
    uint256 public projectCount;

    event ProjectLogged(string name, uint256 budget, string status);
    event ProjectFlagged(string name, uint256 score, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized audit attempt.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logProject(string memory name, uint256 budget) public onlySteward {
        projectCount++;
        projects[projectCount] = Project({
            name: name,
            budget: budget,
            timestamp: block.timestamp,
            corruptionScore: 0,
            isFlagged: false
        });

        emit ProjectLogged(name, budget, "Logged. Awaiting audit.");
    }

    function flagProject(uint256 projectId, uint256 score) public onlySteward {
        require(projectId <= projectCount, "Invalid project ID.");
        projects[projectId].corruptionScore = score;
        projects[projectId].isFlagged = score >= 70;

        string memory reason = score >= 70 ? "Flagged for corruption. Damay clause revoked." : "Clean. Civic resonance intact.";
        emit ProjectFlagged(projects[projectId].name, score, reason);
    }

    function auditProject(uint256 projectId) public view returns (string memory) {
        Project memory p = projects[projectId];
        return string(abi.encodePacked(
            "Project: ", p.name,
            " | Budget: ₱", uint2str(p.budget),
            " | Corruption Score: ", uint2str(p.corruptionScore),
            " | Flagged: ", p.isFlagged ? "Yes" : "No"
        ));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
