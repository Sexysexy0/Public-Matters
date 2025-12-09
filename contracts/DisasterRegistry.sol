// contracts/DisasterRegistry.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DisasterRegistry
 * @notice Register families affected by typhoons/calamities with income and household size.
 */
contract DisasterRegistry {
    struct Family {
        string name;
        uint256 incomeMonthly;   // in local currency per month
        uint8 householdSize;     // 3-8 typical range
        bool disasterAffected;
        bool registered;
    }

    mapping(address => Family) public families;
    address public admin;

    event FamilyRegistered(address indexed wallet, string name, uint256 incomeMonthly, uint8 householdSize, bool disasterAffected);
    event FamilyUpdated(address indexed wallet, uint256 incomeMonthly, uint8 householdSize, bool disasterAffected);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerFamily(
        address wallet,
        string calldata name,
        uint256 incomeMonthly,
        uint8 householdSize,
        bool disasterAffected
    ) external onlyAdmin {
        require(!families[wallet].registered, "Already registered");
        families[wallet] = Family(name, incomeMonthly, householdSize, disasterAffected, true);
        emit FamilyRegistered(wallet, name, incomeMonthly, householdSize, disasterAffected);
    }

    function updateFamily(
        address wallet,
        uint256 incomeMonthly,
        uint8 householdSize,
        bool disasterAffected
    ) external onlyAdmin {
        require(families[wallet].registered, "Not registered");
        families[wallet].incomeMonthly = incomeMonthly;
        families[wallet].householdSize = householdSize;
        families[wallet].disasterAffected = disasterAffected;
        emit FamilyUpdated(wallet, incomeMonthly, householdSize, disasterAffected);
    }

    function getFamily(address wallet) external view returns (Family memory) {
        require(families[wallet].registered, "Not registered");
        return families[wallet];
    }
}
