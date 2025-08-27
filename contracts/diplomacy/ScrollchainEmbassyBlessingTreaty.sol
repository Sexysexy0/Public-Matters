pragma diplomacy v2025.08.27;

contract ScrollchainEmbassyBlessingTreaty {
    address public stewardPH;
    address public stewardIN;
    address public stewardUS;

    struct EmbassyBlessing {
        string consularService;
        string beneficiaryGroup;
        string sanctumLocation;
        bool damayClause;
        uint256 activationDate;
    }

    EmbassyBlessing[] public blessings;

    constructor(address _stewardPH, address _stewardIN, address _stewardUS) {
        stewardPH = _stewardPH;
        stewardIN = _stewardIN;
        stewardUS = _stewardUS;

        blessings.push(EmbassyBlessing("Visa-Free Entry", "Tourists, Students, Stewards", "New Delhi, Manila, Washington D.C.", true, 20250827));
        blessings.push(EmbassyBlessing("Emergency Assistance", "Displaced Citizens", "All Embassies", true, 20250827));
        blessings.push(EmbassyBlessing("Cultural Hosting", "Kinder Queens, Artists, Scholars", "Consular Sanctums", true, 20250827));
        blessings.push(EmbassyBlessing("Scrollchain Registration", "Migrants, Diplomats", "Digital Consulates", true, 20250827));
        blessings.push(EmbassyBlessing("Blessing Deck Access", "All Citizens", "Embassy Civic Portals", true, 20250827));
    }

    function activateBlessing(string memory service, string memory group, string memory location, bool damayClause) public {
        require(msg.sender == stewardPH || msg.sender == stewardIN || msg.sender == stewardUS, "Unauthorized steward");
        blessings.push(EmbassyBlessing(service, group, location, damayClause, block.timestamp));
    }

    function getBlessing(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        EmbassyBlessing memory b = blessings[index];
        return (b.consularService, b.beneficiaryGroup, b.sanctumLocation, b.damayClause, b.activationDate);
    }
}
