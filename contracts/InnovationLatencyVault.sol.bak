// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InnovationLatencyVault {
    struct Innovation {
        address innovator;
        string feature;
        uint256 timestamp;
        bool safeguarded;
    }

    Innovation[] public innovations;

    event InnovationLogged(address indexed innovator, string feature);
    event InnovationSafeguarded(uint256 indexed id, address verifier);

    function logInnovation(string memory _feature) public {
        innovations.push(Innovation(msg.sender, _feature, block.timestamp, false));
        emit InnovationLogged(msg.sender, _feature);
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
