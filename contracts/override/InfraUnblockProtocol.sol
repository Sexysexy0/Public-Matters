// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract InfraUnblockProtocol {
    mapping(string => bool) public stalledProjects;
    event ProjectUnblocked(string projectName, uint256 timestamp);

    function markStalled(string memory projectName) public {
        stalledProjects[projectName] = true;
    }

    function unblockProject(string memory projectName) public {
        require(stalledProjects[projectName], "Project not marked as stalled");
        stalledProjects[projectName] = false;
        emit ProjectUnblocked(projectName, block.timestamp);
    }

    function isStalled(string memory projectName) public view returns (bool) {
        return stalledProjects[projectName];
    }
}
