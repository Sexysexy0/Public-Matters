pragma solidity ^0.8.20;

contract PolicyReformProtocol {
    address public admin;

    struct Reform {
        string authority;    // e.g. wage board, legislature
        string proposal;     // e.g. unify wage rates nationwide
        string impact;       // e.g. reduce inequality, improve labor equity
        uint256 timestamp;
    }

    Reform[] public reforms;

    event ReformLogged(string authority, string proposal, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logReform(string calldata authority, string calldata proposal, string calldata impact) external onlyAdmin {
        reforms.push(Reform(authority, proposal, impact, block.timestamp));
        emit ReformLogged(authority, proposal, impact, block.timestamp);
    }

    function totalReforms() external view returns (uint256) {
        return reforms.length;
    }
}
