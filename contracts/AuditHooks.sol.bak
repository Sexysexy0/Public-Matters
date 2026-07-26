// contracts/AuditHooks.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./InvariantGuard.sol";

contract AuditHooks {
    using InvariantGuard for address;

    event PairChecked(address indexed pair);
    event CriticalDesync(address indexed pair);

    function checkPair(address pair) external {
        try this._assert(pair) {
            emit PairChecked(pair);
        } catch {
            emit CriticalDesync(pair);
            revert("AMM reserves desynced");
        }
    }

    function _assert(address pair) external view {
        pair.assertSync();
    }
}
