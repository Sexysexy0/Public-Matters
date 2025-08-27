pragma audit v2025.08.27;

contract CivicAuditPulse_PH {
    address public stewardCitizen;
    address public stewardCOA;
    address public stewardSenate;

    struct AuditBlessing {
        string projectName;
        string agency;
        string location;
        uint256 budgetPHP;
        bool ghostDetected;
        bool damayClause;
        uint256 activationDate;
    }

    AuditBlessing[] public blessings;

    constructor(address _citizen, address _coa, address _senate) {
        stewardCitizen = _citizen;
        stewardCOA = _coa;
        stewardSenate = _senate;

        blessings.push(AuditBlessing("Flood Control Phase 3", "DPWH", "Malolos", 120_000_000, true, true, 20250827));
        blessings.push(AuditBlessing("Barangay Road Rehab", "LGU", "Calumpit", 35_000_000, true, true, 20250827));
        blessings.push(AuditBlessing("School Roof Upgrade", "DepEd", "Hagonoy", 18_000_000, false, true, 20250827));
    }

    function activateAudit(string memory project, string memory agency, string memory location, uint256 budgetPHP, bool ghostDetected, bool damayClause) public {
        require(msg.sender == stewardCitizen || msg.sender == stewardCOA || msg.sender == stewardSenate, "Unauthorized steward");
        blessings.push(AuditBlessing(project, agency, location, budgetPHP, ghostDetected, damayClause, block.timestamp));
    }

    function getAudit(uint index) public view returns (string memory, string memory, string memory, uint256, bool, bool, uint256) {
        AuditBlessing memory b = blessings[index];
        return (b.projectName, b.agency, b.location, b.budgetPHP, b.ghostDetected, b.damayClause, b.activationDate);
    }
}
