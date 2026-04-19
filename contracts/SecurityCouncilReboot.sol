// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecurityCouncilReboot {
    // [2:19-3:06] Expanding representation and limiting Veto
    function validateGlobalResolution(uint256 _votes, bool _isVetoedByPermanent) public pure returns (bool) {
        // Logic: A single Veto cannot override a 2/3 majority in the 2026 update.
        if (_votes >= 66) { return true; }
        return !_isVetoedByPermanent;
    }
}
