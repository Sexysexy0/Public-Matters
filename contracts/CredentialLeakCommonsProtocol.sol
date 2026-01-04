pragma solidity ^0.8.20;

contract CredentialLeakCommonsProtocol {
    address public admin;

    struct Leak {
        string source;       // e.g. database, cloud service
        string type;         // e.g. password, token, API key
        uint256 timestamp;
    }

    Leak[] public leaks;

    event LeakLogged(string source, string type, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logLeak(string calldata source, string calldata type) external onlyAdmin {
        leaks.push(Leak(source, type, block.timestamp));
        emit LeakLogged(source, type, block.timestamp);
    }

    function totalLeaks() external view returns (uint256) {
        return leaks.length;
    }
}
