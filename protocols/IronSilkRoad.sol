// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IronSilkRoad {
    // [Goal: Connect distant regions through high-capacity rail]
    function scheduleFreight(string memory _origin, string memory _destination, uint256 _tonnage) external pure returns (string memory) {
        return string(abi.encodePacked("DEPARTING: ", _tonnage, " tons of goods moving from ", _origin, " to ", _destination));
    }
}
