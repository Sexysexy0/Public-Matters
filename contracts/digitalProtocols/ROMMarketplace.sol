// SPDX-License-Identifier: Modder-Market-License
pragma solidity ^0.8.19;

contract ROMMarketplace {
    struct ROM {
        string name;
        string steward;
        uint priceInWei;
        bool rootEnabled;
        bool scrollCertified;
    }

    ROM[] public listings;
    address public steward;

    constructor() {
        steward = msg.sender;

        listings.push(ROM("LineageOS+", "OpenSourceCollective", 0, true, true));
        listings.push(ROM("PixelPlusUI Pro", "PixelSteward", 50000000000000000, true, true)); // 0.05 ETH
        listings.push(ROM("EvolutionX Elite", "EvoDev", 75000000000000000, true, true)); // 0.075 ETH
    }

    function listROM(string memory name, string memory stewardName, uint price, bool rootEnabled) public {
        listings.push(ROM(name, stewardName, price, rootEnabled, true));
    }

    function purchaseROM(uint index) public payable {
        require(index < listings.length, "Invalid ROM index");
        require(msg.value >= listings[index].priceInWei, "Insufficient payment");
        // Scroll-certified transfer logic would go here
    }

    function totalROMs() public view returns (uint) {
        return listings.length;
    }
}
