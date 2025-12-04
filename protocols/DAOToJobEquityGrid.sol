// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToJobEquityGrid {
    string public batchID = "1321.9.243";
    string public steward = "Vinvin";

    address public admin;

    struct Job {
        string sector;     // tech, education, healthcare, agriculture
        string status;     // equitable, pending, ghost
        uint256 timestamp;
    }

    Job[] public jobs;

    event JobLogged(string sector, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logJob(string memory sector, string memory status) public onlyAdmin {
        jobs.push(Job(sector, status, block.timestamp));
        emit JobLogged(sector, status);
    }

    function getJob(uint256 index) public view returns (string memory sector, string memory status, uint256 timestamp) {
        Job memory j = jobs[index];
        return (j.sector, j.status, j.timestamp);
    }
}
