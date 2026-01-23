pragma solidity ^0.8.20;

contract ChaosInfluenceProtocol {
    address public admin;

    struct Influence {
        string country;      // e.g. foreign actor
        string method;       // e.g. funding opposing sides
        string outcome;      // e.g. unrest, government collapse
        uint256 timestamp;
    }

    Influence[] public influences;

    event InfluenceLogged(string country, string method, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logInfluence(string calldata country, string calldata method, string calldata outcome) external onlyAdmin {
        influences.push(Influence(country, method, outcome, block.timestamp));
        emit InfluenceLogged(country, method, outcome, block.timestamp);
    }

    function totalInfluences() external view returns (uint256) {
        return influences.length;
    }
}
