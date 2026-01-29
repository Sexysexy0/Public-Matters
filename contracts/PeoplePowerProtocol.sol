pragma solidity ^0.8.20;

contract PeoplePowerProtocol {
    address public admin;

    struct Movement {
        string cause;        // e.g. Accountability, Inequality
        string action;       // e.g. Protest, Reform push
        uint256 timestamp;
    }

    Movement[] public movements;

    event MovementLogged(string cause, string action, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMovement(string calldata cause, string calldata action) external onlyAdmin {
        movements.push(Movement(cause, action, block.timestamp));
        emit MovementLogged(cause, action, block.timestamp);
    }

    function totalMovements() external view returns (uint256) {
        return movements.length;
    }
}
