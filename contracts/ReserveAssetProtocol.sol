pragma solidity ^0.8.20;

contract ReserveAssetProtocol {
    address public admin;

    struct Reserve {
        string asset;        // e.g. BTC, Gold, USD
        uint256 amount;      // symbolic holdings
        string role;         // e.g. Hedge, Treasury
        uint256 timestamp;
    }

    Reserve[] public reserves;

    event ReserveLogged(string asset, uint256 amount, string role, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logReserve(string calldata asset, uint256 amount, string calldata role) external onlyAdmin {
        reserves.push(Reserve(asset, amount, role, block.timestamp));
        emit ReserveLogged(asset, amount, role, block.timestamp);
    }

    function totalReserves() external view returns (uint256) {
        return reserves.length;
    }
}
