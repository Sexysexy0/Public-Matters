// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract FloodSolutionArbiter {
    address public citizenVotingDAO;
    mapping(address => bool) public isArbiter;

    event CitizenVotingDAOUpdated(address indexed oldDAO, address indexed newDAO);
    event ArbiterStatusChanged(address indexed arbiter, bool indexed status);

    modifier onlyVotingDAO() {
        require(msg.sender == citizenVotingDAO, "Only CitizenVotingDAO authorized");
        _;
    }

    constructor(address _citizenVotingDAO) {
        require(_citizenVotingDAO != address(0), "Zero address input validation guard");
        citizenVotingDAO = _citizenVotingDAO;
    }

    function addArbiter(address _arbiter) external onlyVotingDAO {
        require(_arbiter != address(0), "Zero address configuration block");
        isArbiter[_arbiter] = true;
        emit ArbiterStatusChanged(_arbiter, true);
    }

    function removeArbiter(address _arbiter) external onlyVotingDAO {
        require(_arbiter != address(0), "Zero address configuration block");
        isArbiter[_arbiter] = false;
        emit ArbiterStatusChanged(_arbiter, false);
    }
}
