pragma solidity ^0.8.20;

contract HumanRightsViolationProtocol {
    address public admin;

    struct Violation {
        string actor;        // e.g. ICE, federal agents
        string typeOf;       // e.g. killing, kidnapping, torture
        string victim;       // e.g. migrant, green card holder, citizen
        uint256 timestamp;
    }

    Violation[] public violations;

    event ViolationLogged(string actor, string typeOf, string victim, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logViolation(string calldata actor, string calldata typeOf, string calldata victim) external onlyAdmin {
        violations.push(Violation(actor, typeOf, victim, block.timestamp));
        emit ViolationLogged(actor, typeOf, victim, block.timestamp);
    }

    function totalViolations() external view returns (uint256) {
        return violations.length;
    }
}
