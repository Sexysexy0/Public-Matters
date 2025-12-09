// contracts/MetroSentinel.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SignalOracle.sol";
import "./GuardianRoles.sol";

contract MetroSentinel {
    address public owner;
    GuardianRoles public guardianRoles;
    SignalOracle public signalOracle;

    event SignalAdjusted(string intersection, uint256 newCycle);
    event RerouteSuggested(string route, string reason);
    event EnforcementLogged(address guardian, string action);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address guardianAddr, address oracleAddr) {
        owner = msg.sender;
        guardianRoles = GuardianRoles(guardianAddr);
        signalOracle = SignalOracle(oracleAddr);
    }

    function adjustSignal(string calldata intersection, uint256 newCycle) external onlyOwner {
        emit SignalAdjusted(intersection, newCycle);
    }

    function suggestReroute(string calldata route, string calldata reason) external onlyOwner {
        emit RerouteSuggested(route, reason);
    }

    function logEnforcement(address guardian, string calldata action) external onlyOwner {
        emit EnforcementLogged(guardian, action);
    }
}
