// SPDX-License-Identifier: SanctumRouting-License
pragma solidity ^0.8.0;

contract ExpertRoutingSanctumOracle {
    address public steward;

    struct TaskFlow {
        string domain;
        uint256 aprLevel;
        string sanctum;
        uint256 timestamp;
    }

    TaskFlow[] public flows;

    event TaskFlowEmitted(string domain, uint256 aprLevel, string sanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitTaskFlow(string memory domain, uint256 aprLevel, string memory sanctum) public {
        require(msg.sender == steward, "Only steward can emit");
        flows.push(TaskFlow(domain, aprLevel, sanctum, block.timestamp));
        emit TaskFlowEmitted(domain, aprLevel, sanctum, block.timestamp);
    }

    function getFlow(uint index) public view returns (string memory, uint256, string memory, uint256) {
        TaskFlow memory f = flows[index];
        return (f.domain, f.aprLevel, f.sanctum, f.timestamp);
    }

    function totalFlows() public view returns (uint) {
        return flows.length;
    }
}
