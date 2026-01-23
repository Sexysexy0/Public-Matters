pragma solidity ^0.8.20;

contract PropagandaProtocol {
    address public admin;

    struct Propaganda {
        string source;       // e.g. state media, covert channel
        string message;      // e.g. destabilizing narrative
        string impact;       // e.g. sway opinion, fuel unrest
        uint256 timestamp;
    }

    Propaganda[] public propagandas;

    event PropagandaLogged(string source, string message, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPropaganda(string calldata source, string calldata message, string calldata impact) external onlyAdmin {
        propagandas.push(Propaganda(source, message, impact, block.timestamp));
        emit PropagandaLogged(source, message, impact, block.timestamp);
    }

    function totalPropagandas() external view returns (uint256) {
        return propagandas.length;
    }
}
