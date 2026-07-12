// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Omnipotence
/// @notice Absolute power and capability safeguard contract
contract CovenantOmnipotence {
    address public guardian;
    uint256 public powerCount;

    struct Power {
        uint256 id;
        string domain;
        string capability;
        bool constrained;
    }

    mapping(uint256 => Power) public powers;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event PowerDeclared(uint256 indexed id, string domain, string capability);

    constructor() {
        guardian = msg.sender;
        powerCount = 0;
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

    function declarePower(string calldata domain, string calldata capability, bool constrained) external onlyGuardian {
        powerCount++;
        powers[powerCount] = Power(powerCount, domain, capability, constrained);
        emit PowerDeclared(powerCount, domain, capability);
    }

    function viewPower(uint256 id) external view returns (Power memory) {
        return powers[id];
    }
}
