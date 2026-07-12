// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Apocalypse
/// @notice End-of-cycle closure and systemic reset contract
contract CovenantApocalypse {
    address public guardian;
    uint256 public apocalypseCount;

    struct Closure {
        uint256 id;
        string covenantName;
        string terminationCause;
        string resetPath;
        bool executed;
    }

    mapping(uint256 => Closure) public closures;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event ClosureDeclared(uint256 indexed id, string covenantName, string terminationCause);
    event ClosureExecuted(uint256 indexed id, string resetPath);

    constructor() {
        guardian = msg.sender;
        apocalypseCount = 0;
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

    /// @notice Mag‑declare ng covenant closure
    function declareClosure(string calldata covenantName, string calldata terminationCause) external onlyGuardian {
        apocalypseCount++;
        closures[apocalypseCount] = Closure(apocalypseCount, covenantName, terminationCause, "", false);
        emit ClosureDeclared(apocalypseCount, covenantName, terminationCause);
    }

    /// @notice Mag‑execute ng closure at mag‑assign ng reset path
    function executeClosure(uint256 id, string calldata resetPath) external onlyGuardian {
        Closure storage c = closures[id];
        require(!c.executed, "Already executed");
        c.resetPath = resetPath;
        c.executed = true;
        emit ClosureExecuted(id, resetPath);
    }

    /// @notice Tingnan ang closure details
    function viewClosure(uint256 id) external view returns (Closure memory) {
        return closures[id];
    }
}
