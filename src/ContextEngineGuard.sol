// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract ContextEngineGuard {
    bytes32 private immutable SYSTEM_CONTEXT;
    bool private operationalLock;

    error InvalidContext(bytes32 provided, bytes32 expected);
    error BaselineViolation(string reason);
    error SystemLocked();

    constructor(bytes32 _coreContext) {
        SYSTEM_CONTEXT = _coreContext;
        operationalLock = false;
    }

    modifier enforceContext(bytes32 _actionContext) {
        if (_actionContext != SYSTEM_CONTEXT) {
            revert InvalidContext(_actionContext, SYSTEM_CONTEXT);
        }
        if (operationalLock) {
            revert SystemLocked();
        }
        _;
    }

    modifier maintainBaseline(uint256 _currentMetric, uint256 _maxThreshold) {
        if (_currentMetric > _maxThreshold) {
            revert BaselineViolation("External input exceeded safe operational baseline");
        }
        _;
    }

    function _triggerEmergencyLock() internal {
        operationalLock = true;
    }
}
