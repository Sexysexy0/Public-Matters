// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract HomeBaseSupportHub is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(string => uint256) public techUpgrades;

    // Upgrading gear while the other is exploring [20:06]
    function remoteUpgrade(string memory _gearType) public {
        // Logic: While the partner is underwater, 
        // their battery capacity or pressure resistance suddenly increases.
        techUpgrades[_gearType]++;
    }
}
