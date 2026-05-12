// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InnovationEquityShield {
    struct Innovation {
        address creator;
        string project;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Innovation[] public innovations;

    event InnovationLogged(address indexed creator, string project, string safeguard);
    event InnovationSafeguarded(uint256 indexed id, address verifier);

    function logInnovation(string memory _project, string memory _safeguard) public {
        innovations.push(Innovation(msg.sender, _project, _safeguard, block.timestamp, false));
        emit InnovationLogged(msg.sender, _project, _safeguard);
    }

    function safeguardInnovation(uint256 _id) public {
        require(_id < innovations.length, "Invalid ID");
        innovations[_id].safeguarded = true;
        emit InnovationSafeguarded(_id, msg.sender);
    }

    function getInnovation(uint256 _id) public view returns (Innovation memory) {
        require(_id < innovations.length, "Invalid ID");
        return innovations[_id];
    }

    function totalInnovations() public view returns (uint256) {
        return innovations.length;
    }
}
