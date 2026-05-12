// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GenderDynamicsOracle {
    struct Discourse {
        address participant;
        string theme;
        uint256 timestamp;
        bool balanced;
    }

    Discourse[] public discourses;

    event DiscourseLogged(address indexed participant, string theme);
    event DiscourseBalanced(uint256 indexed id, address mediator);

    function logDiscourse(string memory _theme) public {
        discourses.push(Discourse(msg.sender, _theme, block.timestamp, false));
        emit DiscourseLogged(msg.sender, _theme);
    }

    function balanceDiscourse(uint256 _id) public {
        require(_id < discourses.length, "Invalid ID");
        discourses[_id].balanced = true;
        emit DiscourseBalanced(_id, msg.sender);
    }

    function getDiscourse(uint256 _id) public view returns (Discourse memory) {
        require(_id < discourses.length, "Invalid ID");
        return discourses[_id];
    }

    function totalDiscourses() public view returns (uint256) {
        return discourses.length;
    }
}
