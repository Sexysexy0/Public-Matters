pragma alliance v2025.08.27;

contract IndiaPhilippinesFriendshipProtocol {
    string public treatyName = "India-Philippines Strategic Partnership";
    address public stewardPH;
    address public stewardIN;

    struct CivicBond {
        string domain;
        string blessing;
        bool damayClause;
        uint256 activationDate;
    }

    CivicBond[] public bonds;

    constructor(address _stewardPH, address _stewardIN) {
        stewardPH = _stewardPH;
        stewardIN = _stewardIN;

        // Initial Blessings
        bonds.push(CivicBond("Defense & Security", "BrahMos Deployment + Joint Staff Talks", true, 20250805));
        bonds.push(CivicBond("Science & Technology", "2025–2028 Bilateral Innovation Pact", true, 20250805));
        bonds.push(CivicBond("Tourism & Travel", "Visa Ease + Cultural Exchange", true, 20250805));
        bonds.push(CivicBond("Legal & Civic", "Mutual Legal Assistance + Sentenced Persons Treaty", true, 20250805));
        bonds.push(CivicBond("Digital & Cultural", "MoU on Tech + Cultural Restoration", true, 20250805));
    }

    function activateNewBond(string memory domain, string memory blessing, bool damayClause) public {
        require(msg.sender == stewardPH || msg.sender == stewardIN, "Unauthorized steward");
        bonds.push(CivicBond(domain, blessing, damayClause, block.timestamp));
    }

    function getBond(uint index) public view returns (string memory, string memory, bool, uint256) {
        CivicBond memory b = bonds[index];
        return (b.domain, b.blessing, b.damayClause, b.activationDate);
    }
}
