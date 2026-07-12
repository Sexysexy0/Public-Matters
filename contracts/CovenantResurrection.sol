// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Resurrection
/// @notice Revival and rebirth contract for covenant governance system
contract CovenantResurrection {
    address public guardian;
    uint256 public resurrectionCount;

    struct Resurrection {
        uint256 id;
        string covenantName;
        string triggerEvent;
        string revivalAction;
        bool completed;
    }

    mapping(uint256 => Resurrection) public resurrections;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event ResurrectionDeclared(uint256 indexed id, string covenantName, string triggerEvent);
    event ResurrectionCompleted(uint256 indexed id, string revivalAction);

    constructor() {
        guardian = msg.sender;
        resurrectionCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑declare ng resurrection event
    function declareResurrection(string calldata covenantName, string calldata triggerEvent) external onlyGuardian {
        resurrectionCount++;
        resurrections[resurrectionCount] = Resurrection(resurrectionCount, covenantName, triggerEvent, "", false);
        emit ResurrectionDeclared(resurrectionCount, covenantName, triggerEvent);
    }

    /// @notice Mag‑complete ng resurrection at mag‑assign ng revival action
    function completeResurrection(uint256 id, string calldata revivalAction) external onlyGuardian {
        Resurrection storage r = resurrections[id];
        require(!r.completed, "Already completed");
        r.revivalAction = revivalAction;
        r.completed = true;
        emit ResurrectionCompleted(id, revivalAction);
    }

    /// @notice Tingnan ang resurrection details
    function viewResurrection(uint256 id) external view returns (Resurrection memory) {
        return resurrections[id];
    }
}
