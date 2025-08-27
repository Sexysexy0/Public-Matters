pragma protection v2025.08.27;

contract WitnessProtectionTreaty_PH {
    address public stewardDOJ;
    address public stewardCitizen;
    address public stewardSenate;

    struct ProtectionBlessing {
        string witnessName;
        string caseType;
        string agencyInvolved;
        bool threatConfirmed;
        bool damayClause;
        uint256 activationDate;
    }

    ProtectionBlessing[] public blessings;

    constructor(address _doj, address _citizen, address _senate) {
        stewardDOJ = _doj;
        stewardCitizen = _citizen;
        stewardSenate = _senate;

        blessings.push(ProtectionBlessing("DPWH Engineer #001", "Flood Control Corruption", "DPWH", true, true, 20250827));
        blessings.push(ProtectionBlessing("Barangay Whistle #002", "Ghost Project Exposure", "LGU", true, true, 20250827));
    }

    function activateBlessing(string memory witnessName, string memory caseType, string memory agency, bool threatConfirmed, bool damayClause) public {
        require(msg.sender == stewardDOJ || msg.sender == stewardCitizen || msg.sender == stewardSenate, "Unauthorized steward");
        blessings.push(ProtectionBlessing(witnessName, caseType, agency, threatConfirmed, damayClause, block.timestamp));
    }

    function getBlessing(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        ProtectionBlessing memory b = blessings[index];
        return (b.witnessName, b.caseType, b.agencyInvolved, b.threatConfirmed, b.damayClause, b.activationDate);
    }
}
