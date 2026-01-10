 pragma solidity ^0.8.20;

contract ConnectionWeaverProtocol {
    address public admin;

    struct Connection {
        string party;        // e.g. investor, partner, community
        string purpose;      // e.g. funding, alliance, audit
        uint256 timestamp;
    }

    Connection[] public connections;

    event ConnectionLogged(string party, string purpose, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logConnection(string calldata party, string calldata purpose) external onlyAdmin {
        connections.push(Connection(party, purpose, block.timestamp));
        emit ConnectionLogged(party, purpose, block.timestamp);
    }

    function totalConnections() external view returns (uint256) {
        return connections.length;
    }
}
