pragma solidity ^0.8.20;

contract CyberOpsProtocol {
    address public admin;

    struct CyberOp {
        string actor;        // e.g. MSS, CIA, independent hacker
        string method;       // e.g. malware, phishing, DDoS
        string effect;       // e.g. data breach, surveillance expansion
        uint256 timestamp;
    }

    CyberOp[] public cyberOps;

    event CyberOpLogged(string actor, string method, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCyberOp(string calldata actor, string calldata method, string calldata effect) external onlyAdmin {
        cyberOps.push(CyberOp(actor, method, effect, block.timestamp));
        emit CyberOpLogged(actor, method, effect, block.timestamp);
    }

    function totalCyberOps() external view returns (uint256) {
        return cyberOps.length;
    }
}
