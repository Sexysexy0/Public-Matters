// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract BitMarketSanctionRouter {
    mapping(address => bool) public sanctionedVendors;
    event TradeRedirected(address indexed vendor, string destinationSanctum);
    event CoinTagged(address indexed sender, string tag);

    function blockVendor(address vendor) external {
        sanctionedVendors[vendor] = true;
    }

    function redirectTrade(address vendor, string memory sanctum) external {
        require(sanctionedVendors[vendor], "Vendor not sanctioned");
        emit TradeRedirected(vendor, sanctum);
    }

    function tagCoin(address sender) external {
        emit CoinTagged(sender, "No Complicity");
    }
}
