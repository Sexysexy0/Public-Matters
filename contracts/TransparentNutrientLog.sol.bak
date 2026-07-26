// TransparentNutrientLog.sol
// Logic: Immutable Portion Verification
pragma solidity ^0.8.0;

contract TransparentNutrientLog {
    function verifyServing(uint256 _expectedWeight, uint256 _actualWeight) public pure returns (string memory) {
        // Goal: Stop the "Portion Wars".
        // No more "Protein Cup" exit signs.
        if (_actualWeight < _expectedWeight) {
            return "SKIMPING_DETECTED: INITIATE_PARTIAL_REFUND";
        }
        return "PORTION_VERIFIED: SOVEREIGN_STANDARD_MET";
    }
}
