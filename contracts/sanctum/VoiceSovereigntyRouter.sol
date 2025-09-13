// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VoiceSovereigntyRouter {
    enum DisclosureType { Whistleblower, AnonymousComplaint, PublicInterestTestimony }
    enum ShieldLevel { Basic, LegalAid, FullImmunity }

    struct VoiceBlessing {
        uint256 id;
        DisclosureType disclosureType;
        ShieldLevel shieldLevel;
        string jurisdictionTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => VoiceBlessing) public voiceRegistry;
    uint256 public voiceCount;

    event VoiceLogged(uint256 id, DisclosureType disclosureType, ShieldLevel shieldLevel);
    event ShieldUpdated(uint256 id, ShieldLevel newShieldLevel);

    function logVoice(
        DisclosureType disclosureType,
        ShieldLevel shieldLevel,
        string memory jurisdictionTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        voiceRegistry[voiceCount] = VoiceBlessing(
            voiceCount,
            disclosureType,
            shieldLevel,
            jurisdictionTag,
            clauseReference,
            timestamp
        );
        emit VoiceLogged(voiceCount, disclosureType, shieldLevel);
        voiceCount++;
    }

    function updateShield(uint256 id, ShieldLevel newShieldLevel) public {
        require(id < voiceCount, "Invalid voice ID");
        voiceRegistry[id].shieldLevel = newShieldLevel;
        emit ShieldUpdated(id, newShieldLevel);
    }

    function getVoiceBlessing(uint256 id) public view returns (VoiceBlessing memory) {
        return voiceRegistry[id];
    }
}
