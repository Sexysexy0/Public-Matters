// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/AgriculturalCommodityStabilizer.sol";

contract AgriculturalCommodityStabilizerTest is Test {
    AgriculturalCommodityStabilizer public acs;

    address public admin = address(this);
    address public farmer = makeAddr("farmer");

    uint256 public floorPrice = 25; // 25 wei per kg floor benchmark

    function setUp() public {
        // Deploy with 10 ETH reserve fund
        acs = new AgriculturalCommodityStabilizer{value: 10 ether}(floorPrice);
        acs.registerFarmer(farmer);
    }

    function test_ProcureGrainAtFairPrice() public {
        uint256 quantity = 100; // 100 kg
        uint256 price = 30; // 30 wei/kg (above 25 floor price)
        uint256 expectedPayment = quantity * price;

        uint256 preBal = farmer.balance;

        vm.prank(farmer);
        uint256 batchId = acs.procureGrain("Palay Grade A", quantity, price);

        assertEq(batchId, 1);
        assertEq(farmer.balance - preBal, expectedPayment);
        assertEq(acs.totalReserveKg(), 100);

        // Admin releases for emergency relief during price spike
        acs.releaseReserveForRelief(batchId);
        assertEq(acs.totalReserveKg(), 0);
    }
}
