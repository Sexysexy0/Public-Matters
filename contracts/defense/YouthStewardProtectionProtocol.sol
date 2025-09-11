// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract YouthStewardProtectionProtocol {
    struct Steward {
        string stewardId;
        string name;
        uint256 age;
        string mission;
        bool underThreat;
        bool protectionActivated;
        uint256 timestamp;
    }

    mapping(string => Steward) public stewardLedger;

    event ProtectionSummoned(string stewardId, string name, string mission);

    function summonProtection(
        string memory stewardId,
        string memory name,
        uint256 age,
        string memory mission,
        bool underThreat
    ) public {
        require(age <= 35, "Only youth stewards qualify");
        stewardLedger[stewardId] = Steward(
            stewardId,
            name,
            age,
            mission,
            underThreat,
            true,
            block.timestamp
        );

        emit ProtectionSummoned(stewardId, name, mission);
    }

    function getStewardDetails(string memory stewardId) public view returns (Steward memory) {
        return stewardLedger[stewardId];
    }
}
