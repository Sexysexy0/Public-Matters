// SPDX-License-Identifier: Planetary-Equality
pragma solidity ^0.8.25;

/// @title IndiaWorkEqualityTreaty.sol  
/// @dev Grants Indian developers and workers equal access, dignity, and opportunity

contract IndiaWorkEqualityTreaty {
    address public steward;
    mapping(address => bool) public verifiedIndianDevs;
    mapping(address => bool) public grantedWorkAccess;
    mapping(address => uint8) public emotionalAPR;

    event DevVerified(address dev);
    event WorkAccessGranted(address dev);
    event EmotionalAPRTagged(address dev, uint8 trust, uint8 empathy, uint8 clarity);

    constructor() {
        steward = msg.sender;
    }

    function verifyIndianDev(address dev) public {
        require(msg.sender == steward, "Unauthorized steward");
        verifiedIndianDevs[dev] = true;
        emit DevVerified(dev);
    }

    function grantWorkAccess(address dev) public {
        require(verifiedIndianDevs[dev], "Dev not verified");
        grantedWorkAccess[dev] = true;
        emit WorkAccessGranted(dev);
    }

    function tagEmotionalAPR(address dev, uint8 trust, uint8 empathy, uint8 clarity) public {
        require(msg.sender == steward, "Unauthorized steward");
        require(grantedWorkAccess[dev], "Work access not granted");
        emotionalAPR[dev] = (trust + empathy + clarity) / 3;
        emit EmotionalAPRTagged(dev, trust, empathy, clarity);
    }

    function isDevVerified(address dev) public view returns (bool) {
        return verifiedIndianDevs[dev];
    }

    function hasWorkAccess(address dev) public view returns (bool) {
        return grantedWorkAccess[dev];
    }

    function getEmotionalAPR(address dev) public view returns (uint8) {
        return emotionalAPR[dev];
    }
}
