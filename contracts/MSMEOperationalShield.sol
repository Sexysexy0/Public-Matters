// MSMEOperationalShield.sol
// Logic: Accessing the P4-B DTI Crisis Fund
pragma solidity ^0.8.0;

contract MSMEOperationalShield {
    uint256 public constant MAX_NO_COLLATERAL = 5000000; // PHP 5M Limit

    function applyForCrisisLoan(uint256 _requestedAmount) public pure returns (string memory) {
        if (_requestedAmount <= MAX_NO_COLLATERAL) {
            return "ELIGIBLE: NO COLLATERAL REQUIRED | 1-YEAR GRACE PERIOD ACTIVE";
        }
        return "NOTICE: COLLATERAL REQUIRED FOR AMOUNTS ABOVE 5M";
    }
}
