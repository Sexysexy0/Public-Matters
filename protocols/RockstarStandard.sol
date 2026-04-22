// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RockstarStandard {
    // [Goal: Maintain a standard so high that it exposes the flaws of the mediocre]
    function setStandard(string memory _benchmark) external pure returns (string memory) {
        return string(abi.encodePacked("STATUS: Personal benchmark set to '", _benchmark, "'. No compromises."));
    }
}
