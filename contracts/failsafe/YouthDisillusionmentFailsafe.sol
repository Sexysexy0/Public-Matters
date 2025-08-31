// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract YouthDisillusionmentFailsafe {
    event DisillusionmentSpike(string region, uint256 despairIndex, string trigger);
    event RestorationProtocolActivated(string region);

    mapping(string => uint256) public despairIndex;
    uint256 public activationThreshold = 60;

    function reportSpike(string memory region, uint256 index, string memory trigger) public {
        despairIndex[region] = index;
        emit DisillusionmentSpike(region, index, trigger);
        if (index >= activationThreshold) {
            emit RestorationProtocolActivated(region);
        }
    }

    function updateThreshold(uint256 newThreshold) public {
        activationThreshold = newThreshold;
    }

    function getDespairIndex(string memory region) public view returns (uint256) {
        return despairIndex[region];
    }
}
