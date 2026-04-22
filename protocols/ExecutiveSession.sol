// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ExecutiveSession {
    // [Goal: Restricted viewing of sensitive state variables]
    function openSensitiveBox(bool _isExecutiveSession) external pure returns (string memory) {
        if (_isExecutiveSession) {
            return "ACCESS_GRANTED: Proceeding with private examination of records.";
        }
        return "ACCESS_DENIED: Citing NIRC Privacy Protocols. Deferring to session.";
    }
}
