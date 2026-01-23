pragma solidity ^0.8.20;

contract InfluenceOperationProtocol {
    address public admin;

    struct Operation {
        string actor;        // e.g. foreign agency, NGO front
        string method;       // e.g. funding opposition, propaganda
        string outcome;      // e.g. unrest, political chaos
        uint256 timestamp;
    }

    Operation[] public operations;

    event OperationLogged(string actor, string method, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logOperation(string calldata actor, string calldata method, string calldata outcome) external onlyAdmin {
        operations.push(Operation(actor, method, outcome, block.timestamp));
        emit OperationLogged(actor, method, outcome, block.timestamp);
    }

    function totalOperations() external view returns (uint256) {
        return operations.length;
    }
}
