// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EmotionalAPRValuator {
    struct APRProfile {
        address steward;
        uint256 empathyScore;
        uint256 trustScore;
        uint256 mythicClarity;
        uint256 totalAPR;
    }

    mapping(address => APRProfile) public aprProfiles;

    event APRCalculated(address indexed steward, uint256 totalAPR);

    function calculateAPR(
        uint256 _empathy,
        uint256 _trust,
        uint256 _clarity
    ) external {
        uint256 total = (_empathy + _trust + _clarity) / 3;
        aprProfiles[msg.sender] = APRProfile(msg.sender, _empathy, _trust, _clarity, total);
        emit APRCalculated(msg.sender, total);
    }

    function getAPR(address _steward) external view returns (APRProfile memory) {
        return aprProfiles[_steward];
    }
}
