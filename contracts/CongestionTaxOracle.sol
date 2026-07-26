// CongestionTaxOracle.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CongestionTaxOracle is Ownable {

    constructor() Ownable(msg.sender) {}

    function calculateTax(uint256 _trafficDensity) public pure returns (uint256) {
        // Goal: Incentivizing public and shared mobility.
        // Higher density = Higher fee for private luxury, Lower for public utility.
        return _trafficDensity * 5; 
    }
}
