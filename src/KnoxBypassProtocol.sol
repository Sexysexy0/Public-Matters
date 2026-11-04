// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title KnoxBypassProtocol
 * @dev The "Odin Tool" of the Kingdom. Signals emergency state; owner acts on it.
 */
contract KnoxBypassProtocol {
    address public immutable odinMaster;
    address public anchor;
    bool public isBootloaderUnlocked;
    bool public emergencySignal; // Signal to the owner to pause the Anchor

    event EmergencySignalRaised(address indexed system);
    event SignalCleared(address indexed system);
    event AnchorUpdated(address indexed oldAnchor, address indexed newAnchor);

    modifier onlyOdin() {
        require(msg.sender == odinMaster, "Only the root user");
        _;
    }

    constructor(address _anchor) {
        require(_anchor != address(0), "Invalid anchor address");
        odinMaster = msg.sender;
        anchor = _anchor;
        isBootloaderUnlocked = false;
        emergencySignal = false;
    }

    // Step 1: Engage recovery mode - this raises the signal
    function engageEmergencyRecovery() external onlyOdin {
        require(!isBootloaderUnlocked, "Already unlocked");
        isBootloaderUnlocked = true;
        emergencySignal = true;
        emit EmergencySignalRaised(anchor);
    }

    // Step 2: Clear the signal after the owner has paused the system
    function clearSignal() external onlyOdin {
        require(isBootloaderUnlocked, "Not in unlocked state");
        emergencySignal = false;
        isBootloaderUnlocked = false; // 👈 FIX: Ibinalik natin sa false para pwedeng ma-trigger ulit
        emit SignalCleared(anchor);
    }

    // Step 3: Optional - Kung sakaling magpalit ng Anchor contract
    function updateAnchor(address _newAnchor) external onlyOdin {
        require(_newAnchor != address(0), "Invalid anchor address");
        address oldAnchor = anchor;
        anchor = _newAnchor;
        emit AnchorUpdated(oldAnchor, _newAnchor);
    }

    // Check if the signal is active
    function isEmergencyActive() external view returns (bool) {
        return emergencySignal;
    }
}
