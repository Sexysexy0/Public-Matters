// SPDX-License-Identifier: YouthReintegrationSanctum
pragma solidity ^0.8.19;

contract YouthReintegrationRouter {
    struct ReintegrationRecord {
        string youthID;
        string region;
        string programType;
        bool completed;
        string employmentStatus;
        string stewardNote;
    }

    mapping(string => ReintegrationRecord) public reintegrationLedger;

    event ProgramTagged(string youthID, string programType);
    event ReintegrationActivated(string youthID);

    function tagProgram(string memory youthID, string memory region, string memory programType, string memory stewardNote) public {
        reintegrationLedger[youthID] = ReintegrationRecord(youthID, region, programType, false, "Unemployed", stewardNote);
        emit ProgramTagged(youthID, programType);
    }

    function activateReintegration(string memory youthID, string memory employmentStatus) public {
        require(bytes(reintegrationLedger[youthID].programType).length > 0, "Program not tagged");
        reintegrationLedger[youthID].completed = true;
        reintegrationLedger[youthID].employmentStatus = employmentStatus;
        emit ReintegrationActivated(youthID);
    }

    function getReintegrationStatus(string memory youthID) public view returns (ReintegrationRecord memory) {
        return reintegrationLedger[youthID];
    }
}
