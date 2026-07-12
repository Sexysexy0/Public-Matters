// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Eternity
/// @notice Perpetual and timeless safeguard contract
contract CovenantEternity {
    address public guardian;
    uint256 public eternityCount;

    struct Perpetuity {
        uint256 id;
        string subject;
        string timelessPrinciple;
        bool active;
    }

    mapping(uint256 => Perpetuity) public perpetuities;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event EternityDeclared(uint256 indexed id, string subject, string timelessPrinciple);

    constructor() {
        guardian = msg.sender;
        eternityCount = 0;
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

    function declareEternity(string calldata subject, string calldata timelessPrinciple) external onlyGuardian {
        eternityCount++;
        perpetuities[eternityCount] = Perpetuity(eternityCount, subject, timelessPrinciple, true);
        emit EternityDeclared(eternityCount, subject, timelessPrinciple);
    }

    function viewEternity(uint256 id) external view returns (Perpetuity memory) {
        return perpetuities[id];
    }
}
