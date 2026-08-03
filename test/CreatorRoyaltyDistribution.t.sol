// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/CreatorRoyaltyDistribution.sol";

contract CreatorRoyaltyDistributionTest is Test {
    CreatorRoyaltyDistribution public crd;

    address public singer = address(0x1);
    address public guitarist = address(0x2);
    address public listener = address(0x3);

    function setUp() public {
        crd = new CreatorRoyaltyDistribution();

        address[] memory wallets = new address[](2);
        wallets[0] = singer;
        wallets[1] = guitarist;

        uint256[] memory shares = new uint256[](2);
        shares[0] = 6000; // 60%
        shares[1] = 4000; // 40%

        // Register Track 1 ("This World Is Not My Home")
        vm.prank(singer);
        crd.registerTrack("This World Is Not My Home", "QmIPFSMusicMetadataHash", wallets, shares);
    }

    function test_PayRoyaltySplitsCorrectly() public {
        uint256 singerInitialBal = singer.balance;
        uint256 guitaristInitialBal = guitarist.balance;

        // Listener pays 1 ETH royalty/stream fee
        vm.deal(listener, 1 ether);
        vm.prank(listener);
        crd.payRoyalty{value: 1 ether}(1);

        // Verify 60% (0.6 ETH) went to Singer and 40% (0.4 ETH) went to Guitarist
        assertEq(singer.balance - singerInitialBal, 0.6 ether);
        assertEq(guitarist.balance - guitaristInitialBal, 0.4 ether);
    }
}
