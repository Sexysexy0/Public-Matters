// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArchetypalHero {
    // [Goal: Re-establish the classic hero dynamic in every life decision]
    function declareStance(string memory _side) external pure returns (string memory) {
        return string(abi.encodePacked("COMMITTED: Fighting for the side of ", _side));
    }
}
