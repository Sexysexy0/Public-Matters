// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmotionalConsentAuditRouter {
    mapping(address => bool) public consentStatus;
    mapping(address => string) public emotionalAPRTag;

    event ConsentActivated(address user, string aprTag);
    event ConsentRevoked(address user);

    function activateConsent(string memory aprTag) public {
        consentStatus[msg.sender] = true;
        emotionalAPRTag[msg.sender] = aprTag;
        emit ConsentActivated(msg.sender, aprTag);
    }

    function revokeConsent() public {
        consentStatus[msg.sender] = false;
        delete emotionalAPRTag[msg.sender];
        emit ConsentRevoked(msg.sender);
    }

    function isConsentActive(address user) public view returns (bool) {
        return consentStatus[user];
    }

    function getAPRTag(address user) public view returns (string memory) {
        return emotionalAPRTag[user];
    }
}
