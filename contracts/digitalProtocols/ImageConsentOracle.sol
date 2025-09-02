// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ImageConsentOracle {
    mapping(string => bool) public consentTags;

    function tagConsent(string memory imageHash) public {
        consentTags[imageHash] = true;
    }

    function revokeConsent(string memory imageHash) public {
        consentTags[imageHash] = false;
    }

    function verifyConsent(string memory imageHash) public view returns (bool) {
        return consentTags[imageHash];
    }
}
