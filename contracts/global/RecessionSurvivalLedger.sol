// SPDX-License-Identifier: EconomicSanctum
pragma solidity ^0.8.19;

contract RecessionSurvivalLedger {
    struct StewardStatus {
        string stewardName;
        bool incomeDisrupted;
        bool housingThreatened;
        bool foodInsecure;
        bool reliefActivated;
        string dignityTag;
    }

    mapping(address => StewardStatus) public ledger;

    event StatusLogged(address indexed steward, string stewardName, bool incomeDisrupted, bool housingThreatened, bool foodInsecure);
    event ReliefActivated(address indexed steward, string dignityTag);

    function logStatus(
        string memory stewardName,
        bool incomeDisrupted,
        bool housingThreatened,
        bool foodInsecure
    ) public {
        ledger[msg.sender] = StewardStatus(
            stewardName,
            incomeDisrupted,
            housingThreatened,
            foodInsecure,
            false,
            ""
        );
        emit StatusLogged(msg.sender, stewardName, incomeDisrupted, housingThreatened, foodInsecure);
    }

    function activateRelief(address steward, string memory dignityTag) public {
        require(
            ledger[steward].incomeDisrupted || ledger[steward].housingThreatened || ledger[steward].foodInsecure,
            "Relief requires hardship signal"
        );
        ledger[steward].reliefActivated = true;
        ledger[steward].dignityTag = dignityTag;
        emit ReliefActivated(steward, dignityTag);
    }

    function getStatus(address steward) public view returns (StewardStatus memory) {
        return ledger[steward];
    }
}
