// contracts/CounterIntel.sol
pragma solidity ^0.8.20;

contract CounterIntel {
    address public admin;

    struct Operation {
        string target;      // "SpyRing", "InfluenceOps"
        string description;
        uint256 timestamp;
    }

    Operation[] public operations;

    event OperationLogged(string target, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logOperation(string calldata target, string calldata description) external onlyAdmin {
        operations.push(Operation(target, description, block.timestamp));
        emit OperationLogged(target, description, block.timestamp);
    }
}
