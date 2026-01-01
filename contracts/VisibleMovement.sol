// contracts/VisibleMovement.sol
pragma solidity ^0.8.20;

/**
 * @title VisibleMovement
 * @notice Logs movements visible to observers but not the underlying vision.
 */
contract VisibleMovement {
    address public admin;

    struct Movement {
        string action;
        uint256 timestamp;
    }

    Movement[] public movements;

    event MovementLogged(string action, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logMovement(string calldata action) external onlyAdmin {
        movements.push(Movement(action, block.timestamp));
        emit MovementLogged(action, block.timestamp);
    }
}
