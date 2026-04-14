// TrueValueAudit.sol
// Logic: Price Transparency & Markup Guard
pragma solidity ^0.8.0;

contract TrueValueAudit {
    struct Product {
        string brand;
        uint256 productionCost;
        uint256 retailPrice;
    }

    function calculateMarkup(uint256 _cost, uint256 _retail) public pure returns (uint256) {
        // Logic: (Retail - Cost) / Cost * 100
        // If Markup > 1000%, flag as "Illusion Value"
        return ((_retail - _cost) * 100) / _cost;
    }
}
