// SPDX-License-Identifier: MIT
// Contract Name: PromotionPathClause
// Purpose: Define fair career advancement rules
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract PromotionPathClause {
    address public chiefOperator;
    uint256 public pathCount;

    struct Path {
        string level;           // e.g., Junior, Senior, Manager
        string criteria;        // e.g., 6 months performance, training completion
        string safeguard;       // e.g., Audit, Peer review
        uint256 timestamp;
    }

    Path[] public paths;

    event PathAdded(string level, string criteria, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        pathCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new promotion path
    function addPath(string memory level, string memory criteria, string memory safeguard) public onlyChief {
        paths.push(Path(level, criteria, safeguard, block.timestamp));
        pathCount++;
        emit PathAdded(level, criteria, safeguard, block.timestamp);
    }

    // View promotion path details
    function getPath(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < paths.length, "Invalid path index");
        Path memory p = paths[index];
        return (p.level, p.criteria, p.safeguard, p.timestamp);
    }
}
