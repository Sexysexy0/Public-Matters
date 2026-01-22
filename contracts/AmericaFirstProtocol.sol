pragma solidity ^0.8.20;

contract AmericaFirstProtocol {
    address public admin;

    struct Policy {
        string initiative;   // e.g. tariff threats, immigration stance
        string target;       // e.g. France, EU
        string effect;       // e.g. trade leverage, sovereignty assertion
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string initiative, string target, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPolicy(string calldata initiative, string calldata target, string calldata effect) external onlyAdmin {
        policies.push(Policy(initiative, target, effect, block.timestamp));
        emit PolicyLogged(initiative, target, effect, block.timestamp);
    }

    function totalPolicies() external view returns (uint256) {
        return policies.length;
    }
}
