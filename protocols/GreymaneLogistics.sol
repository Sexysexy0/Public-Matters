// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GreymaneLogistics {
    // [Goal: Enable Combat Units to Carry Economic Weight]
    function assignCargo(uint256 _weight, string memory _cargoType) external pure returns (string memory) {
        return string(abi.encodePacked("LOGISTICS_LOCKED: Greymanes are now transporting ", _cargoType));
    }
}
