// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrewRecruitment {
    struct CrewMember {
        string role; // "Miner", "Farmer", "Cannoneer"
        uint256 efficiency;
    }

    mapping(uint256 => CrewMember) public crew;

    // [Goal: Assign captured NPCs to automate resource gathering]
    function assignTask(uint256 _id, string memory _role) external {
        crew[_id] = CrewMember(_role, 85); // 85% output speed
    }
}
