// VATRollbackProtocol.sol
pragma solidity ^0.8.0;

contract VATRollbackProtocol {
    uint256 public currentRate = 95; // 9.5% VAT (scaled by 10 for precision)
    uint256 public minRate = 95;
    uint256 public maxRate = 105;

    event RateAdjusted(uint256 newRate, string reason);

    function adjustRate(uint256 revenueHealth) public {
        if (revenueHealth < 70) { // threshold for rollback
            currentRate = 100; // rollback to 10%
            emit RateAdjusted(currentRate, "Rollback triggered due to revenue shortfall.");
        } else if (revenueHealth < 60) {
            currentRate = 105; // rollback to 10.5%
            emit RateAdjusted(currentRate, "Rollback triggered to safeguard fiscal stability.");
        } else {
            currentRate = minRate;
            emit RateAdjusted(currentRate, "Maintained at 9.5% VAT.");
        }
    }
}
