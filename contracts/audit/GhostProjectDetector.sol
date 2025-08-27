pragma audit v2025.08.27;

contract GhostProjectDetector {
    address public stewardCitizen;
    address public stewardCOA;
    address public stewardSenate;

    struct ProjectAudit {
        string projectName;
        string contractor;
        string location;
        uint256 budgetPHP;
        bool physicalEvidence;
        bool paymentReleased;
        bool ghostDetected;
        bool damayClause;
        uint256 activationDate;
    }

    ProjectAudit[] public audits;

    constructor(address _citizen, address _coa, address _senate) {
        stewardCitizen = _citizen;
        stewardCOA = _coa;
        stewardSenate = _senate;

        audits.push(ProjectAudit("Flood Control Phase 3", "Wawao Builders", "Malolos", 120_000_000, false, true, true, true, 20250827));
        audits.push(ProjectAudit("Barangay Road Rehab", "Alpha & Omega", "Calumpit", 35_000_000, false, true, true, true, 20250827));
        audits.push(ProjectAudit("School Roof Upgrade", "Centerways Construction", "Hagonoy", 18_000_000, true, true, false, true, 20250827));
    }

    function logAudit(string memory project, string memory contractor, string memory location, uint256 budgetPHP, bool physicalEvidence, bool paymentReleased, bool ghostDetected, bool damayClause) public {
        require(msg.sender == stewardCitizen || msg.sender == stewardCOA || msg.sender == stewardSenate, "Unauthorized steward");
        audits.push(ProjectAudit(project, contractor, location, budgetPHP, physicalEvidence, paymentReleased, ghostDetected, damayClause, block.timestamp));
    }

    function getAudit(uint index) public view returns (string memory, string memory, string memory, uint256, bool, bool, bool, bool, uint256) {
        ProjectAudit memory a = audits[index];
        return (a.projectName, a.contractor, a.location, a.budgetPHP, a.physicalEvidence, a.paymentReleased, a.ghostDetected, a.damayClause, a.activationDate);
    }
}
