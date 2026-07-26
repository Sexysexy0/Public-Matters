// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CrisisTariffSentry is Ownable {

    constructor() Ownable(msg.sender) {}

    uint256 public globalTransitFee;

    // Kapag ginamit ang Strait as leverage (2:48)
    function adjustSubsidy(uint256 _newFee) public pure returns (string memory) {
        if (_newFee > 10000) {
            return "CRISIS MODE: Activating Emergency Fuel Subsidy for Public Transport.";
        }
        return "Normal Operations: Fees within trade limits.";
    }
}
