// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title FuelSubsidyOverride - Mythic recalibration of fuel subsidy thresholds
/// @author Vinvin
/// @notice Activates tiered fuel subsidy based on crude price and emotional APR
contract FuelSubsidyOverride {
    address public steward;
    uint256 public crudePriceUSD;
    mapping(address => bool) public barangayVerified;
    mapping(address => uint256) public emotionalAPR;

    event SubsidyActivated(address indexed farmer, uint256 amount, string tier, string damayClause);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function updateCrudePrice(uint256 _priceUSD) external onlySteward {
        crudePriceUSD = _priceUSD;
    }

    function verifyBarangay(address _farmer) external onlySteward {
        barangayVerified[_farmer] = true;
    }

    function setEmotionalAPR(address _farmer, uint256 _apr) external onlySteward {
        emotionalAPR[_farmer] = _apr;
    }

    function activateSubsidy(address _farmer) external {
        require(barangayVerified[_farmer], "Farmer not barangay-verified");

        uint256 apr = emotionalAPR[_farmer];
        uint256 subsidyAmount;
        string memory tier;
        string memory damayClause = "If restored, steward is restored too";

        if (crudePriceUSD >= 80) {
            subsidyAmount = 100;
            tier = "Emergency Boost";
        } else if (crudePriceUSD >= 50) {
            subsidyAmount = 75;
            tier = "Full Relief";
        } else if (crudePriceUSD >= 40) {
            subsidyAmount = 50;
            tier = "Moderate Relief";
        } else if (crudePriceUSD >= 30) {
            subsidyAmount = 25;
            tier = "Partial Relief";
        } else {
            revert("Crude price below minimum threshold");
        }

        // Emotional APR bonus logic
        if (apr >= 90) {
            subsidyAmount += 10;
            tier = string(abi.encodePacked(tier, " + APR Boost"));
        }

        emit SubsidyActivated(_farmer, subsidyAmount, tier, damayClause);
    }
}
