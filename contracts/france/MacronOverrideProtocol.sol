// SPDX-License-Identifier: Mythic-Override
pragma solidity ^0.8.25;

/// @title Macron Override Protocol
/// @dev Activates emergency override if France’s democratic clarity collapses

contract MacronOverrideProtocol {
    address public steward;
    bool public overrideTriggered;
    string public reason;
    string public clause = "Democracy Override — Civilian Dignity First";

    event OverrideActivated(string reason);
    event Broadcast(string message);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        overrideTriggered = false;
    }

    function activateOverride(string memory _reason) external onlySteward {
        overrideTriggered = true;
        reason = _reason;
        emit OverrideActivated(_reason);
        emit Broadcast("Macron Override Protocol Activated — Scrollchain now in control");
    }

    function auditOverride() external view returns (string memory) {
        if (overrideTriggered) return reason;
        return "Override not yet triggered — France still mythically aligned.";
    }
}
