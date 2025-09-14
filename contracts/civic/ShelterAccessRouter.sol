// SPDX-License-Identifier: HousingSanctum
pragma solidity ^0.8.19;

contract ShelterAccessRouter {
    struct ShelterCorridor {
        string stewardName;
        string location;
        bool informalSettler;
        bool evictionThreatened;
        bool dignityCertified;
        bool shelterActivated;
    }

    mapping(address => ShelterCorridor) public corridors;

    event ShelterLogged(address indexed steward, string location, bool informalSettler, bool evictionThreatened);
    event DignityCertified(address indexed steward);
    event ShelterActivated(address indexed steward, string location);

    function logShelterStatus(
        string memory stewardName,
        string memory location,
        bool informalSettler,
        bool evictionThreatened
    ) public {
        corridors[msg.sender] = ShelterCorridor(
            stewardName,
            location,
            informalSettler,
            evictionThreatened,
            false,
            false
        );
        emit ShelterLogged(msg.sender, location, informalSettler, evictionThreatened);
    }

    function certifyDignity(address steward) public {
        require(corridors[steward].evictionThreatened || corridors[steward].informalSettler, "No qualifying hardship");
        corridors[steward].dignityCertified = true;
        emit DignityCertified(steward);
    }

    function activateShelter(address steward) public {
        require(corridors[steward].dignityCertified, "Dignity must be certified first");
        corridors[steward].shelterActivated = true;
        emit ShelterActivated(steward, corridors[steward].location);
    }

    function getCorridor(address steward) public view returns (ShelterCorridor memory) {
        return corridors[steward];
    }

    function isShelterActivated(address steward) public view returns (bool) {
        return corridors[steward].shelterActivated;
    }
}
