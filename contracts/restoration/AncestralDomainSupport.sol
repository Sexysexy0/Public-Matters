// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AncestralDomainSupport {
    struct SupportProgram {
        string tribe;
        string domainLocation;
        string programType; // e.g. "Livelihood", "FoodAid", "SolarPower", "LandProtection"
        string implementingAgency; // e.g. "NCIP", "LGU", "DA", "DOE"
        string emotionalTag; // e.g. "AncestorGlow", "DamayClause", "BlessedFlow"
        uint256 timestamp;
    }

    SupportProgram[] public programs;

    event ProgramLogged(string tribe, string domainLocation, string programType, string implementingAgency, string emotionalTag);

    function logProgram(
        string memory _tribe,
        string memory _domainLocation,
        string memory _programType,
        string memory _implementingAgency,
        string memory _emotionalTag
    ) public {
        programs.push(SupportProgram(_tribe, _domainLocation, _programType, _implementingAgency, _emotionalTag, block.timestamp));
        emit ProgramLogged(_tribe, _domainLocation, _programType, _implementingAgency, _emotionalTag);
    }

    function getProgram(uint256 index) public view returns (SupportProgram memory) {
        return programs[index];
    }

    function totalPrograms() public view returns (uint256) {
        return programs.length;
    }
}
