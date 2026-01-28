pragma solidity ^0.8.20;

contract BiasAuditProtocol {
    address public admin;

    struct Bias {
        string source;       // e.g. Grokipedia, mainstream media
        string typeOf;       // e.g. political, cultural, systemic
        string impact;       // e.g. misinformation, skewed perception
        uint256 timestamp;
    }

    Bias[] public biases;

    event BiasLogged(string source, string typeOf, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBias(string calldata source, string calldata typeOf, string calldata impact) external onlyAdmin {
        biases.push(Bias(source, typeOf, impact, block.timestamp));
        emit BiasLogged(source, typeOf, impact, block.timestamp);
    }

    function totalBiases() external view returns (uint256) {
        return biases.length;
    }
}
