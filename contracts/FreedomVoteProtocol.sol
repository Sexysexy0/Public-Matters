pragma solidity ^0.8.20;

contract FreedomVoteProtocol {
    address public admin;

    struct Election {
        string type;         // e.g. presidential, parliamentary
        string status;       // e.g. planned, ongoing, completed
        uint256 timestamp;
    }

    Election[] public elections;

    event ElectionLogged(string type, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logElection(string calldata type, string calldata status) external onlyAdmin {
        elections.push(Election(type, status, block.timestamp));
        emit ElectionLogged(type, status, block.timestamp);
    }

    function totalElections() external view returns (uint256) {
        return elections.length;
    }
}
