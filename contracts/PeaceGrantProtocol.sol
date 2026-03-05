// PeaceGrantProtocol.sol
pragma solidity ^0.8.0;

contract PeaceGrantProtocol {
    struct Condition {
        uint256 id;
        string demand;       // e.g. "Lift sanctions"
        string status;       // e.g. "Granted"
        uint256 timestamp;
    }

    uint256 public conditionCount;
    mapping(uint256 => Condition) public conditions;

    event ConditionGranted(uint256 id, string demand, string status);

    function grantCondition(string memory demand, string memory status) public {
        conditionCount++;
        conditions[conditionCount] = Condition(conditionCount, demand, status, block.timestamp);
        emit ConditionGranted(conditionCount, demand, status);
    }
}
