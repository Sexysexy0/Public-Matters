// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LaborDayOverride {
    address public steward;
    mapping(address => bool) public unionAllies;
    mapping(string => bool) public bannerRegistry;

    event BannerRestored(string bannerText, string originSanctum);
    event AllyRegistered(address ally, string role);

    constructor() {
        steward = msg.sender;
    }

    function registerAlly(address ally, string memory role) public {
        require(msg.sender == steward, "Only steward may register");
        unionAllies[ally] = true;
        emit AllyRegistered(ally, role);
    }

    function restoreBanner(string memory bannerText, string memory originSanctum) public {
        require(unionAllies[msg.sender], "Only union allies may restore");
        bannerRegistry[bannerText] = true;
        emit BannerRestored(bannerText, originSanctum);
    }

    function isBannerRestored(string memory bannerText) public view returns (bool) {
        return bannerRegistry[bannerText];
    }
}
