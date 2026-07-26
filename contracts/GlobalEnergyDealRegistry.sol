// GlobalEnergyDealRegistry.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GlobalEnergyDealRegistry is Ownable {

    constructor() Ownable(msg.sender) {}

    struct AccountabilityLog {
        string stakeholder; // e.g., "Transport Sector", "Energy Grid"
        uint256 subsidizedRate;
        uint256 timestamp;
    }

    AccountabilityLog[] public logs;

    function recordSubsidyBenefit(string memory _sector, uint256 _rate) public {
        logs.push(AccountabilityLog(_sector, _rate, block.timestamp));
    }
}
