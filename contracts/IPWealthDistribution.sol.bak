// IPWealthDistribution.sol
pragma solidity ^0.8.0;

contract IPWealthDistribution {
    uint256 public royaltyPercentage = 10; // 10% Share for IPs

    function distributeRoyalty(uint256 _projectRevenue, address _communityWallet) public payable {
        uint256 share = (_projectRevenue * royaltyPercentage) / 100;
        payable(_communityWallet).transfer(share);
    }
}
