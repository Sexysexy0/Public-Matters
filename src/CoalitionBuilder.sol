// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CoalitionBuilder {
    struct Coalition {
        string mission;
        address[] members;
    }

    Coalition[] public coalitions;

    event CoalitionCreated(uint256 id, string mission);
    event MemberJoined(uint256 id, address member);

    function createCoalition(string calldata mission) external {
        coalitions.push(Coalition(mission, new address[](0)));
        emit CoalitionCreated(coalitions.length - 1, mission);
    }

    function joinCoalition(uint256 id) external {
        coalitions[id].members.push(msg.sender);
        emit MemberJoined(id, msg.sender);
    }

    // ✅ Custom getter for members
    function getMembers(uint256 id) external view returns (address[] memory) {
        return coalitions[id].members;
    }

    // ✅ Custom getter for mission
    function getMission(uint256 id) external view returns (string memory) {
        return coalitions[id].mission;
    }
}
