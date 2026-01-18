pragma solidity ^0.8.20;

contract SocietalConsequenceProtocol {
    address public admin;

    struct Consequence {
        string scenario;     // e.g. job displacement, inequality, abundance
        string outlook;      // e.g. optimistic, pessimistic, policy-dependent
        uint256 timestamp;
    }

    Consequence[] public consequences;

    event ConsequenceLogged(string scenario, string outlook, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logConsequence(string calldata scenario, string calldata outlook) external onlyAdmin {
        consequences.push(Consequence(scenario, outlook, block.timestamp));
        emit ConsequenceLogged(scenario, outlook, block.timestamp);
    }

    function totalConsequences() external view returns (uint256) {
        return consequences.length;
    }
}
