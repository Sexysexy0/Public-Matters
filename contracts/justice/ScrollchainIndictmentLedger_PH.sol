pragma justice v2025.08.27;

contract ScrollchainIndictmentLedger_PH {
    address public stewardDOJ;
    address public stewardCitizen;
    address public stewardSenate;

    struct IndictmentScroll {
        string accusedName;
        string position;
        string caseType;
        string agency;
        bool chargesFiled;
        bool damayClause;
        uint256 activationDate;
    }

    IndictmentScroll[] public scrolls;

    constructor(address _doj, address _citizen, address _senate) {
        stewardDOJ = _doj;
        stewardCitizen = _citizen;
        stewardSenate = _senate;

        scrolls.push(IndictmentScroll("DPWH Engineer #001", "District Engineer", "Ghost Project Fraud", "DPWH", true, true, 20250827));
        scrolls.push(IndictmentScroll("LGU Official #002", "Barangay Captain", "Budget Misuse", "LGU", false, true, 20250827));
        scrolls.push(IndictmentScroll("Contractor #003", "CEO, Wawao Builders", "Overpricing & Non-Delivery", "Private Sector", true, true, 20250827));
    }

    function fileIndictment(string memory name, string memory position, string memory caseType, string memory agency, bool chargesFiled, bool damayClause) public {
        require(msg.sender == stewardDOJ || msg.sender == stewardCitizen || msg.sender == stewardSenate, "Unauthorized steward");
        scrolls.push(IndictmentScroll(name, position, caseType, agency, chargesFiled, damayClause, block.timestamp));
    }

    function getScroll(uint index) public view returns (string memory, string memory, string memory, string memory, bool, bool, uint256) {
        IndictmentScroll memory s = scrolls[index];
        return (s.accusedName, s.position, s.caseType, s.agency, s.chargesFiled, s.damayClause, s.activationDate);
    }
}
