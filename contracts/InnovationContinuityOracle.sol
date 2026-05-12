// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InnovationContinuityOracle {
    struct InnovationCycle {
        address innovator;
        string project;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    InnovationCycle[] public cycles;

    event InnovationLogged(address indexed innovator, string project, string safeguard);
    event InnovationSafeguarded(uint256 indexed id, address verifier);

    function logInnovation(string memory _project, string memory _safeguard) public {
        cycles.push(InnovationCycle(msg.sender, _project, _safeguard, block.timestamp, false));
        emit InnovationLogged(msg.sender, _project, _safeguard);
    }

    function safeguardInnovation(uint256 _id) public {
        require(_id < cycles.length, "Invalid ID");
        cycles[_id].safeguarded = true;
        emit InnovationSafeguarded(_id, msg.sender);
    }

    function getInnovation(uint256 _id) public view returns (InnovationCycle memory) {
        require(_id < cycles.length, "Invalid ID");
        return cycles[_id];
    }

    function totalInnovations() public view returns (uint256) {
        return cycles.length;
    }
}
