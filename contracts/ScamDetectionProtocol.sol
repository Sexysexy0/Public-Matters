pragma solidity ^0.8.20;

contract ScamDetectionProtocol {
    address public admin;

    struct Scam {
        string type;         // e.g. industrial-scale scam, phishing, rug pull
        string effect;       // e.g. inflated transactions, investor losses
        uint256 timestamp;
    }

    Scam[] public scams;

    event ScamLogged(string type, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logScam(string calldata type, string calldata effect) external onlyAdmin {
        scams.push(Scam(type, effect, block.timestamp));
        emit ScamLogged(type, effect, block.timestamp);
    }

    function totalScams() external view returns (uint256) {
        return scams.length;
    }
}
