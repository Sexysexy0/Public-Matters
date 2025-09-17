// SPDX-License-Identifier: RecoverySanctum
pragma solidity ^0.8.19;

contract GlobalRecoveryRouter {
    struct RecoverySignal {
        address stewardID;
        string stewardName;
        string crisisType; // e.g., "Cyber Breach", "Climate Disaster", "Infrastructure Collapse"
        bool resilienceProtocolActivated;
        bool sanctumRestored;
        string stewardNote;
    }

    mapping(address => RecoverySignal) public recoveryRegistry;

    event CrisisTagged(address stewardID, string crisisType);
    event RecoverySanctified(address stewardID);

    function tagCrisis(
        address stewardID,
        string memory stewardName,
        string memory crisisType,
        bool resilienceProtocolActivated,
        bool sanctumRestored,
        string memory stewardNote
    ) public {
        recoveryRegistry[stewardID] = RecoverySignal(
            stewardID,
            stewardName,
            crisisType,
            resilienceProtocolActivated,
            sanctumRestored,
            stewardNote
        );
        emit CrisisTagged(stewardID, crisisType);
    }

    function sanctifyRecovery(address stewardID) public {
        require(bytes(recoveryRegistry[stewardID].stewardName).length > 0, "Crisis not tagged");
        recoveryRegistry[stewardID].sanctumRestored = true;
        emit RecoverySanctified(stewardID);
    }

    function getRecoveryStatus(address stewardID) public view returns (RecoverySignal memory) {
        return recoveryRegistry[stewardID];
    }
}
