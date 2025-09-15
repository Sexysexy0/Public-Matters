// SPDX-License-Identifier: CivicSanctum
pragma solidity ^0.8.19;

contract PoliticalHealingRouter {
    struct IdeologyProfile {
        string name;
        string affiliation;
        bool flaggedForRehabilitation;
        uint256 rehabStart;
        uint256 rehabEnd;
        bool restored;
    }

    mapping(bytes32 => IdeologyProfile) public profiles;

    event ProfileFlagged(string name, string affiliation);
    event RehabilitationStarted(string name, uint256 rehabStart);
    event RestorationCompleted(string name);

    function flagForRehabilitation(string memory name, string memory affiliation) public {
        bytes32 profileId = keccak256(abi.encodePacked(name, affiliation, block.timestamp));
        profiles[profileId] = IdeologyProfile(name, affiliation, true, 0, 0, false);
        emit ProfileFlagged(name, affiliation);
    }

    function startRehabilitation(string memory name, string memory affiliation) public {
        bytes32 profileId = keccak256(abi.encodePacked(name, affiliation, block.timestamp));
        profiles[profileId].rehabStart = block.timestamp;
        profiles[profileId].rehabEnd = block.timestamp + 180 days;
        emit RehabilitationStarted(name, profiles[profileId].rehabStart);
    }

    function completeRestoration(string memory name, string memory affiliation) public {
        bytes32 profileId = keccak256(abi.encodePacked(name, affiliation, block.timestamp));
        require(block.timestamp >= profiles[profileId].rehabEnd, "Rehab period not yet complete");
        profiles[profileId].restored = true;
        emit RestorationCompleted(name);
    }

    function getProfileStatus(string memory name, string memory affiliation) public view returns (IdeologyProfile memory) {
        bytes32 profileId = keccak256(abi.encodePacked(name, affiliation, block.timestamp));
        return profiles[profileId];
    }
}
