// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title ExecutiveDefenseMandate2025
/// @dev Grants conditional executive authority for national defense and foreign conflict response

contract ExecutiveDefenseMandate2025 {
    address public commanderInChief;
    bool public mandateActive;
    string public activationReason;
    uint256 public activationTimestamp;

    event MandateActivated(address indexed authority, string reason, uint256 timestamp);
    event MandateRevoked(address indexed authority, uint256 timestamp);

    constructor(address _commanderInChief) {
        commanderInChief = _commanderInChief;
        mandateActive = false;
    }

    function activateMandate(string memory reason) external {
        require(msg.sender == commanderInChief, "Unauthorized activation");
        require(!mandateActive, "Mandate already active");
        activationReason = reason;
        mandateActive = true;
        activationTimestamp = block.timestamp;
        emit MandateActivated(commanderInChief, reason, activationTimestamp);
    }

    function revokeMandate() external {
        require(msg.sender == commanderInChief, "Unauthorized revocation");
        require(mandateActive, "Mandate not active");
        mandateActive = false;
        emit MandateRevoked(commanderInChief, block.timestamp);
    }

    function getMandateStatus() external view returns (string memory status) {
        if (mandateActive) {
            return "Executive defense mandate is active";
        } else {
            return "No active mandate";
        }
    }
}
