// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Prime
/// @notice Supreme authority and primary safeguard contract
contract CovenantPrime {
    address public guardian;
    uint256 public primeCount;

    struct Primacy {
        uint256 id;
        string domain;
        string authorityPrinciple;
        bool enforced;
    }

    mapping(uint256 => Primacy) public primacies;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event PrimeDeclared(uint256 indexed id, string domain, string authorityPrinciple);

    constructor() {
        guardian = msg.sender;
        primeCount = 0;
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

    function declarePrime(
        string calldata domain,
        string calldata authorityPrinciple,
        bool enforced
    ) external onlyGuardian {
        primeCount++;
        primacies[primeCount] = Primacy(primeCount, domain, authorityPrinciple, enforced);
        emit PrimeDeclared(primeCount, domain, authorityPrinciple);
    }

    function viewPrime(uint256 id) external view returns (Primacy memory) {
        return primacies[id];
    }
}
