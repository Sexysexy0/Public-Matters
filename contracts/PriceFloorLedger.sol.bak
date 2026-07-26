// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PriceFloorLedger {
    event FloorSeal(string tier, uint256 price);

    function setPriceFloor(string memory _tier, uint256 _price) external {
        emit FloorSeal(_tier, _price);
        // RULE: Game Pass Ultimate fixed at $15.
    }
}
