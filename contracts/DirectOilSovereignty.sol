// DirectOilSovereignty.sol
pragma solidity ^0.8.0;

contract DirectOilSovereignty {
    struct EnergyDeal {
        uint256 dealId;
        string partnerNation; // e.g., "Russia", "USA"
        uint256 pricePerBarrelUSD; // Target: 20-30 USD
        uint256 volumeCommitment;
        bool isActive;
    }

    mapping(uint256 => EnergyDeal) public deals;
    uint256 public totalDeals;

    event DealFormalized(uint256 id, string nation, uint256 price);

    function formalizeDeal(string memory _nation, uint256 _price, uint256 _volume) public {
        totalDeals++;
        deals[totalDeals] = EnergyDeal(totalDeals, _nation, _price, _volume, true);
        emit DealFormalized(totalDeals, _nation, _price);
    }
}
