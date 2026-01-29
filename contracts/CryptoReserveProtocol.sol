pragma solidity ^0.8.20;

contract CryptoReserveProtocol {
    address public admin;

    struct Reserve {
        string asset;         // e.g. BTC, ETH
        uint256 amount;       // symbolic holdings
        string purpose;       // e.g. Treasury, Diversification
        uint256 timestamp;
    }

    Reserve[] public reserves;

    event ReserveLogged(string asset, uint256 amount, string purpose, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logReserve(string calldata asset, uint256 amount, string calldata purpose) external onlyAdmin {
        reserves.push(Reserve(asset, amount, purpose, block.timestamp));
        emit ReserveLogged(asset, amount, purpose, block.timestamp);
    }

    function totalReserves() external view returns (uint256) {
        return reserves.length;
    }
}
