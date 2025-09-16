// SPDX-License-Identifier: ReefSanctum
pragma solidity ^0.8.19;

contract ReefProtectionSanctifier {
    struct ReefSignal {
        string reefID;
        string restorationStatus;
        string patrolUnit;
        bool protected;
        string stewardNote;
    }

    mapping(string => ReefSignal) public reefRegistry;

    event ReefTagged(string reefID, string restorationStatus);
    event ReefSanctified(string reefID);

    function tagReef(string memory reefID, string memory restorationStatus, string memory patrolUnit, string memory stewardNote) public {
        reefRegistry[reefID] = ReefSignal(reefID, restorationStatus, patrolUnit, false, stewardNote);
        emit ReefTagged(reefID, restorationStatus);
    }

    function sanctifyReef(string memory reefID) public {
        require(bytes(reefRegistry[reefID].patrolUnit).length > 0, "Reef not tagged");
        reefRegistry[reefID].protected = true;
        emit ReefSanctified(reefID);
    }

    function getReefStatus(string memory reefID) public view returns (ReefSignal memory) {
        return reefRegistry[reefID];
    }
}
