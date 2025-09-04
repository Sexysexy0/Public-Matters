// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title HouseTaxBlessing - Progressive Property Taxation Protocol for Sovereign Equity
/// @author Vinvin
/// @notice Tags high-value properties, calculates tax, and emits emotional resonance.

contract HouseTaxBlessing {
    address public steward;
    uint256 public baseRate = 15; // 1.5% default tax rate
    uint256 public blessingThreshold = 300_000; // ₱/sqm threshold for ultra-high-end

    struct Property {
        uint256 areaSqm;
        uint256 valuePerSqm;
        string barangay;
        string emotionalTag;
        bool blessed;
    }

    mapping(address => Property) public propertyLedger;
    mapping(address => uint256) public taxLedger;

    event PropertyBlessed(address owner, uint256 taxDue, string emotionalTag);
    event ThresholdUpdated(uint256 newThreshold);
    event BaseRateUpdated(uint256 newRate);

    constructor() {
        steward = msg.sender;
    }

    function registerProperty(
        address _owner,
        uint256 _areaSqm,
        uint256 _valuePerSqm,
        string calldata _barangay,
        string calldata _emotionalTag
    ) external {
        require(msg.sender == steward, "Only steward may register.");
        propertyLedger[_owner] = Property(_areaSqm, _valuePerSqm, _barangay, _emotionalTag, false);
    }

    function blessProperty(address _owner) external {
        require(msg.sender == steward, "Only steward may bless.");
        Property storage prop = propertyLedger[_owner];
        require(!prop.blessed, "Already blessed.");

        uint256 totalValue = prop.areaSqm * prop.valuePerSqm;
        require(prop.valuePerSqm >= blessingThreshold, "Property below blessing threshold.");

        uint256 taxDue = (totalValue * baseRate) / 1000; // 1.5% = 15/1000
        taxLedger[_owner] = taxDue;
        prop.blessed = true;

        emit PropertyBlessed(_owner, taxDue, prop.emotionalTag);
    }

    function updateThreshold(uint256 _newThreshold) external {
        require(msg.sender == steward, "Only steward may update.");
        blessingThreshold = _newThreshold;
        emit ThresholdUpdated(_newThreshold);
    }

    function updateBaseRate(uint256 _newRate) external {
        require(msg.sender == steward, "Only steward may update.");
        baseRate = _newRate;
        emit BaseRateUpdated(_newRate);
    }

    function getTaxDue(address _owner) external view returns (uint256) {
        return taxLedger[_owner];
    }
}
