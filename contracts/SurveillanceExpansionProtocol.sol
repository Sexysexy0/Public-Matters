pragma solidity ^0.8.20;

contract SurveillanceExpansionProtocol {
    address public admin;

    struct Expansion {
        string method;       // e.g. satellite, cyber intrusion, phone tapping
        string scope;        // e.g. domestic, foreign
        string effect;       // e.g. broader monitoring, deeper reach
        uint256 timestamp;
    }

    Expansion[] public expansions;

    event ExpansionLogged(string method, string scope, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logExpansion(string calldata method, string calldata scope, string calldata effect) external onlyAdmin {
        expansions.push(Expansion(method, scope, effect, block.timestamp));
        emit ExpansionLogged(method, scope, effect, block.timestamp);
    }

    function totalExpansions() external view returns (uint256) {
        return expansions.length;
    }
}
