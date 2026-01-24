pragma solidity ^0.8.20;

contract VolatilityCompressionProtocol {
    address public admin;

    struct Compression {
        string asset;        // e.g. Bitcoin, Tesla, Nvidia
        string measure;      // e.g. realized volatility, implied volatility
        string trend;        // e.g. decreasing, stable, breakout risk
        uint256 timestamp;
    }

    Compression[] public compressions;

    event CompressionLogged(string asset, string measure, string trend, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCompression(string calldata asset, string calldata measure, string calldata trend) external onlyAdmin {
        compressions.push(Compression(asset, measure, trend, block.timestamp));
        emit CompressionLogged(asset, measure, trend, block.timestamp);
    }

    function totalCompressions() external view returns (uint256) {
        return compressions.length;
    }
}
