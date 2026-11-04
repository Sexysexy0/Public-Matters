// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecurityConfig {
    uint256 public constant MAX_OUTFLOW_LIMIT = 100 ether;
    bool public circuitBreakerTriggered = false;

    event CircuitBreakerToggled(bool status);

    function triggerCircuitBreaker(bool _status) external {
        circuitBreakerTriggered = _status;
        emit CircuitBreakerToggled(_status);
    }
}
