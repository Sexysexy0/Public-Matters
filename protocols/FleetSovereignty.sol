// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FleetSovereignty {
    // [Goal: Command a high-capacity vessel for long-range exploration]
    function deployGalleon(string memory _captainName) external pure returns (string memory) {
        return string(abi.encodePacked("COMMISSIONED: The Flagship of ", _captainName, " is now seaworthy."));
    }
}
