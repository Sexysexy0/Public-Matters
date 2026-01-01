// contracts/HiddenVision.sol
pragma solidity ^0.8.20;

/**
 * @title HiddenVision
 * @notice Logs invisible visions not broadcast to observers.
 */
contract HiddenVision {
    address public admin;

    struct Vision {
        string description;
        uint256 timestamp;
    }

    Vision[] public visions;

    event VisionLogged(string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logVision(string calldata description) external onlyAdmin {
        visions.push(Vision(description, block.timestamp));
        emit VisionLogged(description, block.timestamp);
    }
}
