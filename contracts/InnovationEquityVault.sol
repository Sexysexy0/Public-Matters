// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InnovationEquityVault {
    struct Innovation {
        address innovator;
        string description;
        uint256 timestamp;
        bool verified;
    }

    Innovation[] public innovations;

    event InnovationLogged(address indexed innovator, string description);
    event InnovationVerified(uint256 indexed id, address verifier);

    function logInnovation(string memory _desc) public {
        innovations.push(Innovation(msg.sender, _desc, block.timestamp, false));
        emit InnovationLogged(msg.sender, _desc);
    }

    function verifyInnovation(uint256 _id) public {
        require(_id < innovations.length, "Invalid ID");
        innovations[_id].verified = true;
        emit InnovationVerified(_id, msg.sender);
    }

    function getInnovation(uint256 _id) public view returns (Innovation memory) {
        require(_id < innovations.length, "Invalid ID");
        return innovations[_id];
    }

    function totalInnovations() public view returns (uint256) {
        return innovations.length;
    }
}
