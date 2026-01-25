pragma solidity ^0.8.20;

contract CorrelationProtocol {
    address public admin;

    struct Correlation {
        string assetPair;    // e.g. BTC vs Nasdaq-100
        string value;        // e.g. 0.16 correlation
        string context;      // e.g. low correlation, independent movement
        uint256 timestamp;
    }

    Correlation[] public correlations;

    event CorrelationLogged(string assetPair, string value, string context, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCorrelation(string calldata assetPair, string calldata value, string calldata context) external onlyAdmin {
        correlations.push(Correlation(assetPair, value, context, block.timestamp));
        emit CorrelationLogged(assetPair, value, context, block.timestamp);
    }

    function totalCorrelations() external view returns (uint256) {
        return correlations.length;
    }
}
