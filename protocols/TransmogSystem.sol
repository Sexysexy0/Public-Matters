// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransmogSystem {
    // [Goal: Separate visual appearance from combat stats]
    function applySkin(string memory _baseGear, string memory _visualSkin) external pure returns (string memory) {
        return string(abi.encodePacked("SUCCESS: ", _baseGear, " now looks like ", _visualSkin));
    }
}
