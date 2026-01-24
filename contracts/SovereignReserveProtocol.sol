pragma solidity ^0.8.20;

contract SovereignReserveProtocol {
    address public admin;

    struct Reserve {
        string country;      // e.g. US, BRICS nation
        string asset;        // e.g. Bitcoin, gold
        string purpose;      // e.g. hedge, diversification, geopolitical leverage
        uint256 timestamp;
    }

    Reserve[] public reserves;

    event ReserveLogged(string country, string asset, string purpose, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logReserve(string calldata country, string calldata asset, string calldata purpose) external onlyAdmin {
        reserves.push(Reserve(country, asset, purpose, block.timestamp));
        emit ReserveLogged(country, asset, purpose, block.timestamp);
    }

    function totalReserves() external view returns (uint256) {
        return reserves.length;
    }
}
