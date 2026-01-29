pragma solidity ^0.8.20;

contract StateReserveProtocol {
    address public admin;

    struct Reserve {
        string asset;        // e.g. Bitcoin, Gold
        uint256 allocation;  // percentage allocation
        uint256 timestamp;
    }

    Reserve[] public reserves;

    event ReserveLogged(string asset, uint256 allocation, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logReserve(string calldata asset, uint256 allocation) external onlyAdmin {
        require(allocation <= 10, "Cap exceeded"); // 10% cap
        reserves.push(Reserve(asset, allocation, block.timestamp));
        emit ReserveLogged(asset, allocation, block.timestamp);
    }

    function totalReserves() external view returns (uint256) {
        return reserves.length;
    }
}
