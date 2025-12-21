// contracts/OilResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title OilResilience
 * @notice Protocol for tracking oil reserves, resilience measures, and communal audit.
 */
contract OilResilience {
    address public admin;

    struct Reserve {
        string location;
        uint256 barrels;
        string note;
        uint256 timestamp;
    }

    Reserve[] public reserves;

    event ReserveLogged(string location, uint256 barrels, string note, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logReserve(string calldata location, uint256 barrels, string calldata note) external onlyAdmin {
        reserves.push(Reserve(location, barrels, note, block.timestamp));
        emit ReserveLogged(location, barrels, note, block.timestamp);
    }

    function totalReserves() external view returns (uint256) {
        return reserves.length;
    }

    function getReserve(uint256 id) external view returns (Reserve memory) {
        require(id < reserves.length, "Invalid id");
        return reserves[id];
    }
}
