// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SpeculationEquityShield {
    struct Theory {
        address participant;
        string theme;
        uint256 timestamp;
        bool safeguarded;
    }

    Theory[] public theories;

    event TheoryLogged(address indexed participant, string theme);
    event TheorySafeguarded(uint256 indexed id, address verifier);

    function logTheory(string memory _theme) public {
        theories.push(Theory(msg.sender, _theme, block.timestamp, false));
        emit TheoryLogged(msg.sender, _theme);
    }

    function safeguardTheory(uint256 _id) public {
        require(_id < theories.length, "Invalid ID");
        theories[_id].safeguarded = true;
        emit TheorySafeguarded(_id, msg.sender);
    }

    function getTheory(uint256 _id) public view returns (Theory memory) {
        require(_id < theories.length, "Invalid ID");
        return theories[_id];
    }

    function totalTheories() public view returns (uint256) {
        return theories.length;
    }
}
