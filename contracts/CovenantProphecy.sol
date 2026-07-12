// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Prophecy
/// @notice Foresight and future vision safeguard contract
contract CovenantProphecy {
    address public guardian;
    uint256 public prophecyCount;

    struct Prophecy {
        uint256 id;
        string subject;
        string foresight;
        uint256 horizonYear;
        bool fulfilled;
    }

    mapping(uint256 => Prophecy) public prophecies;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event ProphecyDeclared(uint256 indexed id, string subject, uint256 horizonYear);
    event ProphecyFulfilled(uint256 indexed id, string foresight);

    constructor() {
        guardian = msg.sender;
        prophecyCount = 0;
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

    /// @notice Mag‑declare ng prophecy foresight
    function declareProphecy(string calldata subject, string calldata foresight, uint256 horizonYear) external onlyGuardian {
        prophecyCount++;
        prophecies[prophecyCount] = Prophecy(prophecyCount, subject, foresight, horizonYear, false);
        emit ProphecyDeclared(prophecyCount, subject, horizonYear);
    }

    /// @notice Mag‑fulfill ng prophecy foresight
    function fulfillProphecy(uint256 id, string calldata foresight) external onlyGuardian {
        Prophecy storage p = prophecies[id];
        require(!p.fulfilled, "Already fulfilled");
        p.foresight = foresight;
        p.fulfilled = true;
        emit ProphecyFulfilled(id, foresight);
    }

    /// @notice Tingnan ang prophecy details
    function viewProphecy(uint256 id) external view returns (Prophecy memory) {
        return prophecies[id];
    }
}
