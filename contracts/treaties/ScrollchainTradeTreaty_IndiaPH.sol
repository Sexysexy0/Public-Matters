pragma treaty v2025.08.27;

contract ScrollchainTradeTreaty_IndiaPH {
    address public stewardPH;
    address public stewardIN;

    struct TradeBlessing {
        string category;
        string item;
        uint256 annualVolumeUSD;
        bool damayClause;
    }

    TradeBlessing[] public blessings;

    constructor(address _stewardPH, address _stewardIN) {
        stewardPH = _stewardPH;
        stewardIN = _stewardIN;

        // Initial Trade Blessings
        blessings.push(TradeBlessing("Pharma", "Generic Medicines", 700000000, true));
        blessings.push(TradeBlessing("Tech", "Semiconductors & Electrical Machinery", 500000000, true));
        blessings.push(TradeBlessing("Agri", "Rice, Bovine Meat, Oil Seeds", 300000000, true));
        blessings.push(TradeBlessing("Metals", "Copper, Lead, Ores", 250000000, true));
        blessings.push(TradeBlessing("Rare Earths", "Neodymium, Lanthanum, Yttrium", 150000000, true));
        blessings.push(TradeBlessing("Civic Goods", "Plastic, Linoleum, Animal Fodder", 100000000, true));
    }

    function proposeBlessing(string memory category, string memory item, uint256 volumeUSD, bool damayClause) public {
        require(msg.sender == stewardPH || msg.sender == stewardIN, "Unauthorized steward");
        blessings.push(TradeBlessing(category, item, volumeUSD, damayClause));
    }

    function getBlessing(uint index) public view returns (string memory, string memory, uint256, bool) {
        TradeBlessing memory b = blessings[index];
        return (b.category, b.item, b.annualVolumeUSD, b.damayClause);
    }
}
