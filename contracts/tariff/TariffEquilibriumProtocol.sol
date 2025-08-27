// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title TariffEquilibriumProtocol.sol
/// @author Vinvin & Copilot
/// @notice Auto-adjusts tariff rates on essential commodities based on market balance and emotional APR.
/// @dev Includes damay clause, fairness logic, and sovereign audit triggers.

contract TariffEquilibriumProtocol {
    address public steward;

    struct Commodity {
        string name;
        uint256 localCost;
        uint256 importCost;
        uint256 retailPrice;
        uint256 tariffRate;
        string emotionalAPR;
        bool isBalanced;
        uint256 timestamp;
    }

    Commodity[] public commodities;

    event TariffAdjusted(
        string name,
        uint256 newTariffRate,
        string emotionalAPR,
        bool isBalanced,
        uint256 timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function assessCommodity(
        string memory name,
        uint256 localCost,
        uint256 importCost,
        uint256 retailPrice
    ) public onlySteward {
        uint256 newTariffRate;
        string memory emotionalAPR;
        bool isBalanced;

        if (importCost < localCost && retailPrice > localCost + 10) {
            newTariffRate = ((localCost - importCost) * 100) / importCost;
            emotionalAPR = "Empathy:Low, Trust:Contested, Clarity:Reactive";
            isBalanced = false;
        } else if (localCost > importCost && retailPrice < localCost + 5) {
            newTariffRate = 0;
            emotionalAPR = "Empathy:High, Trust:Restored, Clarity:Stable";
            isBalanced = true;
        } else {
            newTariffRate = 5;
            emotionalAPR = "Empathy:Moderate, Trust:Operational, Clarity:Pending";
            isBalanced = true;
        }

        commodities.push(Commodity(name, localCost, importCost, retailPrice, newTariffRate, emotionalAPR, isBalanced, block.timestamp));
        emit TariffAdjusted(name, newTariffRate, emotionalAPR, isBalanced, block.timestamp);
    }

    function getCommodityCount() public view returns (uint256) {
        return commodities.length;
    }

    function getCommodityByIndex(uint256 index) public view returns (
        string memory,
        uint256,
        uint256,
        uint256,
        uint256,
        string memory,
        bool,
        uint256
    ) {
        Commodity memory c = commodities[index];
        return (c.name, c.localCost, c.importCost, c.retailPrice, c.tariffRate, c.emotionalAPR, c.isBalanced, c.timestamp);
    }
}
