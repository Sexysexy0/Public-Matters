// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToLeadershipEquityGrid {
    string public batchID = "1321.9.250";
    string public steward = "Vinvin";

    address public admin;

    struct Leadership {
        string program;     // student council, youth parliament, NGO initiative
        string status;      // equitable, pending, ghost
        uint256 timestamp;
    }

    Leadership[] public programs;

    event LeadershipLogged(string program, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logProgram(string memory program, string memory status) public onlyAdmin {
        programs.push(Leadership(program, status, block.timestamp));
        emit LeadershipLogged(program, status);
    }

    function getProgram(uint256 index) public view returns (string memory program, string memory status, uint256 timestamp) {
        Leadership memory l = programs[index];
        return (l.program, l.status, l.timestamp);
    }
}
