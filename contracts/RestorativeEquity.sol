// contracts/RestorativeEquity.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RestorativeEquity
 * @notice Protocol for restorative justice and equity compensation.
 */
contract RestorativeEquity {
    address public admin;

    struct Compensation {
        address recipient;
        uint256 amount;
        string reason;
        uint256 timestamp;
    }

    Compensation[] public compensations;

    event CompensationLogged(address indexed recipient, uint256 amount, string reason, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logCompensation(address recipient, uint256 amount, string calldata reason) external onlyAdmin {
        compensations.push(Compensation(recipient, amount, reason, block.timestamp));
        emit CompensationLogged(recipient, amount, reason, block.timestamp);
    }

    function totalCompensations() external view returns (uint256) {
        return compensations.length;
    }

    function getCompensation(uint256 id) external view returns (Compensation memory) {
        require(id < compensations.length, "Invalid id");
        return compensations[id];
    }
}
