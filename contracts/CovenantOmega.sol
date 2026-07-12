// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Omega
/// @notice Ending and closure safeguard contract
contract CovenantOmega {
    address public guardian;
    uint256 public omegaCount;

    struct End {
        uint256 id;
        string subject;
        string closurePath;
        bool completed;
    }

    mapping(uint256 => End) public ends;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event OmegaDeclared(uint256 indexed id, string subject);
    event OmegaCompleted(uint256 indexed id, string closurePath);

    constructor() {
        guardian = msg.sender;
        omegaCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    function declareOmega(string calldata subject) external onlyGuardian {
        omegaCount++;
        ends[omegaCount] = End(omegaCount, subject, "", false);
        emit OmegaDeclared(omegaCount, subject);
    }

    function completeOmega(uint256 id, string calldata closurePath) external onlyGuardian {
        End storage e = ends[id];
        require(!e.completed, "Already completed");
        e.closurePath = closurePath;
        e.completed = true;
        emit OmegaCompleted(id, closurePath);
    }

    function viewOmega(uint256 id) external view returns (End memory) {
        return ends[id];
    }
}
