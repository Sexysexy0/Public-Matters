// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RiderVerificationSentry {
    // [REPORT: "Bigo pa ring makakuha"]
    function verifyEligibility(bool _activeFranchise, bool _isDeliveryAppVerified) public pure returns (bool) {
        if (_activeFranchise && _isDeliveryAppVerified) {
            return true; // Automatic Whitelist
        }
        return false; // Error: Data Mismatch
    }
}
