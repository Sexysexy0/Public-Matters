// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

contract CoalitionBuilder {
    OperatorPrivileges public privileges;

    struct Coalition {
        string mission;
        address[] members;
    }

    Coalition[] public coalitions;

    event CoalitionCreated(uint256 indexed id, string mission);
    event CoalitionJoined(uint256 indexed id, address member);

    constructor(address _privileges) {
        privileges = OperatorPrivileges(_privileges);
    }

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    function createCoalition(string calldata mission) external onlyOperator {
        // Create new coalition in storage
        uint256 id = coalitions.length;
        coalitions.push();
        coalitions[id].mission = mission;
        coalitions[id].members.push(msg.sender);
        emit CoalitionCreated(id, mission);
    }

    function joinCoalition(uint256 id) external onlyOperator {
        require(id < coalitions.length, "Invalid coalition");
        coalitions[id].members.push(msg.sender);
        emit CoalitionJoined(id, msg.sender);
    }

    function getMembers(uint256 id) external view returns (address[] memory) {
        require(id < coalitions.length, "Invalid coalition");
        return coalitions[id].members;
    }

    function getMission(uint256 id) external view returns (string memory) {
        require(id < coalitions.length, "Invalid coalition");
        return coalitions[id].mission;
    }
}
