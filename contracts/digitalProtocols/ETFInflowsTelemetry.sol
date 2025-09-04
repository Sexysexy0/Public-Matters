// Tracks institutional sentiment and emotional APR shifts
pragma solidity ^0.8.19;

contract ETFInflowsTelemetry {
    uint256 public btcInflows;
    uint256 public ethOutflows;

    event TelemetryUpdated(uint256 btc, uint256 eth);

    function updateTelemetry(uint256 btc, uint256 eth) external {
        btcInflows = _btc;
        ethOutflows = _eth;
        emit TelemetryUpdated(btc, eth);
    }

    function netFlow() public view returns (int256) {
        return int256(btcInflows) - int256(ethOutflows);
    }
}
