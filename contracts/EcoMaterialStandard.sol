// EcoMaterialStandard.sol
// Logic: Carbon-Negative Infrastructure
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract EcoMaterialStandard is Ownable {

    constructor() Ownable(msg.sender) {}

    function calculateCarbonCredit(uint256 _hempVolume) public pure returns (uint256) {
        // Goal: Eco-Friendly Sovereignty.
        // For every ton of hemp used in construction, provide tax credits to the builder.
        return _hempVolume * 15; // 15 points per ton
    }
}
