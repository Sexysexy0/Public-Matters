// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MovementAudit {
    // [Goal: Evaluate if a strategy or movement is still delivering value]
    function isSystemCooked(uint256 _results, uint256 _promises) external pure returns (bool) {
        // Logic: If results are less than 10% of promises, the system is 'Cooked'.
        return (_results * 10 < _promises);
    }
}
