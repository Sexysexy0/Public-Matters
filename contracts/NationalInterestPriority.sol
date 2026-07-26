// NationalInterestPriority.sol
// Logic: Filipino-First Diplomacy
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract NationalInterestPriority is Ownable {

    constructor() Ownable(msg.sender) {}

    function calculateBenefit(uint256 _economicGain, uint256 _securityRisk) public pure returns (bool) {
        // If the risk to our citizens exceeds the economic gain, the deal is OFF.
        return (_economicGain > _securityRisk);
    }
}
