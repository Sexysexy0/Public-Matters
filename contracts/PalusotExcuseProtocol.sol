pragma solidity ^0.8.20;

contract PalusotExcuseProtocol {
    address public admin;

    struct Excuse {
        string reason;       // e.g. free trade reliance, blaming oligarchy
        string effect;       // e.g. blocked industrial policy, weak state capacity
        uint256 timestamp;
    }

    Excuse[] public excuses;

    event ExcuseLogged(string reason, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logExcuse(string calldata reason, string calldata effect) external onlyAdmin {
        excuses.push(Excuse(reason, effect, block.timestamp));
        emit ExcuseLogged(reason, effect, block.timestamp);
    }

    function totalExcuses() external view returns (uint256) {
        return excuses.length;
    }
}
