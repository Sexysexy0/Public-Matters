// SPDX-License-Identifier: Mythic-Oracle
pragma solidity ^0.8.19;

contract EmotionalFailsafeOracle {
    mapping(address => uint256) public emotionalAPR;
    event APRUpdated(address steward, uint256 newAPR);

    function updateAPR(uint256 newAPR) public {
        emotionalAPR[msg.sender] = newAPR;
        emit APRUpdated(msg.sender, newAPR);
    }

    function getAPR(address steward) public view returns (uint256) {
        return emotionalAPR[steward];
    }

    function isFailsafeTriggered(address steward) public view returns (bool) {
        return emotionalAPR[steward] < 45;
    }
}
