// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToLeadershipEquityGridIV {
    string public batchID = "1321.9.259";
    string public steward = "Vinvin";

    address public admin;

    struct Leadership {
        string program;     // youth council, civic training, wage equity, fair transport pricing
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

    function logLeadership(string memory program, string memory status) public onlyAdmin {
        programs.push(Leadership(program, status, block.timestamp));
        emit LeadershipLogged(program, status);
    }
}
