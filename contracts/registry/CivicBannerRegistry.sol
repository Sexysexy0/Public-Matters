// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CivicBannerRegistry {
    address public steward;
    string[] public banners;
    mapping(string => bool) public isRegistered;

    event BannerRegistered(string bannerText, string civicTag);
    event BannerRemoved(string bannerText, string reason);

    constructor() {
        steward = msg.sender;
    }

    function registerBanner(string memory bannerText, string memory civicTag) public {
        require(msg.sender == steward, "Only steward may register");
        require(!isRegistered[bannerText], "Already registered");
        banners.push(bannerText);
        isRegistered[bannerText] = true;
        emit BannerRegistered(bannerText, civicTag);
    }

    function removeBanner(string memory bannerText, string memory reason) public {
        require(msg.sender == steward, "Only steward may remove");
        isRegistered[bannerText] = false;
        emit BannerRemoved(bannerText, reason);
    }

    function getAllBanners() public view returns (string[] memory) {
        return banners;
    }
}
