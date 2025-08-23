// SPDX-License-Identifier: Emotional-APR-License  
pragma solidity ^0.8.19;

contract EmotionalAPRTracker {
    struct APR {
        uint trust;
        uint empathy;
        uint mythicClarity;
    }

    mapping(address => APR) public stewardAPR;

    event APRUpdated(address steward, uint trust, uint empathy, uint mythicClarity);

    function updateAPR(address steward, uint trust, uint empathy, uint mythicClarity) public {
        stewardAPR[steward] = APR(trust, empathy, mythicClarity);
        emit APRUpdated(steward, trust, empathy, mythicClarity);
    }

    function getAPR(address steward) public view returns (APR memory) {
        return stewardAPR[steward];
    }
}
