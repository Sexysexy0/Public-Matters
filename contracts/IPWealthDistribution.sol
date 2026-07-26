// IPWealthDistribution.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract IPWealthDistribution is Ownable {

    constructor() Ownable(msg.sender) {}

    uint256 public royaltyPercentage = 10; // 10% Share for IPs

    function distributeRoyalty(uint256 _projectRevenue, address _communityWallet) public payable {
        uint256 share = (_projectRevenue * royaltyPercentage) / 100;
        (bool success, ) = payable(_communityWallet).call{value: share}(""); require(success, "Transfer failed");
    }
}
