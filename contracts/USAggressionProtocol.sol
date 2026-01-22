pragma solidity ^0.8.20;

contract USAggressionProtocol {
    address public admin;

    struct Aggression {
        string action;       // e.g. tariff threats, annexation imagery
        string target;       // e.g. Canada, EU
        string effect;       // e.g. military modeling, economic strain
        uint256 timestamp;
    }

    Aggression[] public aggressions;

    event AggressionLogged(string action, string target, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAggression(string calldata action, string calldata target, string calldata effect) external onlyAdmin {
        aggressions.push(Aggression(action, target, effect, block.timestamp));
        emit AggressionLogged(action, target, effect, block.timestamp);
    }

    function totalAggressions() external view returns (uint256) {
        return aggressions.length;
    }
}
