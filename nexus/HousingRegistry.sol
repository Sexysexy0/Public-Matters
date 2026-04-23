// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HousingRegistry {
    struct Home {
        string platform; // Minecraft or Roblox
        uint256 plotID;
        string coordinates;
        bool isLocked;
    }
    
    mapping(address => Home) public playerHomes;

    function claimPlot(uint256 _id, string memory _coords, string memory _plat) external {
        playerHomes[msg.sender] = Home(_plat, _id, _coords, true);
    }
}
