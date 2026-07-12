// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Absolute
/// @notice Totality and ultimate safeguard contract
contract CovenantAbsolute {
    address public guardian;
    uint256 public absoluteCount;

    struct Totality {
        uint256 id;
        string subject;
        string totalPrinciple;
        bool binding;
    }

    mapping(uint256 => Totality) public totalities;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event AbsoluteDeclared(uint256 indexed id, string subject, string totalPrinciple);

    constructor() {
        guardian = msg.sender;
        absoluteCount = 0;
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

    function declareAbsolute(string calldata subject, string calldata totalPrinciple, bool binding) external onlyGuardian {
        absoluteCount++;
        totalities[absoluteCount] = Totality(absoluteCount, subject, totalPrinciple, binding);
        emit AbsoluteDeclared(absoluteCount, subject, totalPrinciple);
    }

    function viewAbsolute(uint256 id) external view returns (Totality memory) {
        return totalities[id];
    }
}
