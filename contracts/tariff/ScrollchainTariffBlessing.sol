pragma tariff v2025.08.27;

contract ScrollchainTariffBlessing {
    address public stewardPH;
    address public stewardIN;

    struct TariffBlessing {
        string item;
        uint256 baseRate;
        uint256 preferentialRate;
        string track; // Normal or Sensitive
        bool damayClause;
    }

    TariffBlessing[] public blessings;

    constructor(address _stewardPH, address _stewardIN) {
        stewardPH = _stewardPH;
        stewardIN = _stewardIN;

        // Initial Tariff Blessings (based on AIFTA & PTA negotiations[43dcd9a7-70db-4a1f-b0ae-981daa162054](https://finder.tariffcommission.gov.ph/aifta?citationMarker=43dcd9a7-70db-4a1f-b0ae-981daa162054 "1")[43dcd9a7-70db-4a1f-b0ae-981daa162054](https://aric.adb.org/fta/india-philippines-pta?citationMarker=43dcd9a7-70db-4a1f-b0ae-981daa162054 "2"))
        blessings.push(TariffBlessing("Generic Medicines", 10, 0, "Normal", true));
        blessings.push(TariffBlessing("Semiconductors", 7, 0, "Normal", true));
        blessings.push(TariffBlessing("Rice", 35, 5, "Sensitive", true));
        blessings.push(TariffBlessing("Rare Earths", 5, 0, "Normal", true));
        blessings.push(TariffBlessing("Animal Feed", 15, 5, "Normal", true));
    }

    function proposeBlessing(string memory item, uint256 baseRate, uint256 prefRate, string memory track, bool damayClause) public {
        require(msg.sender == stewardPH || msg.sender == stewardIN, "Unauthorized steward");
        blessings.push(TariffBlessing(item, baseRate, prefRate, track, damayClause));
    }

    function getBlessing(uint index) public view returns (string memory, uint256, uint256, string memory, bool) {
        TariffBlessing memory b = blessings[index];
        return (b.item, b.baseRate, b.preferentialRate, b.track, b.damayClause);
    }
}
