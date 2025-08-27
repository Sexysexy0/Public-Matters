pragma trade v2025.08.27;

contract RareEarthTradeDeck {
    address public stewardPH;
    address public stewardIN;

    struct RareEarth {
        string element;
        string useCase;
        uint256 estimatedValueUSD;
        bool damayClause;
    }

    RareEarth[] public tradeItems;

    constructor(address _stewardPH, address _stewardIN) {
        stewardPH = _stewardPH;
        stewardIN = _stewardIN;

        // Initial Trade Blessings
        tradeItems.push(RareEarth("Neodymium", "EV motors, wind turbines", 70000, true));
        tradeItems.push(RareEarth("Cerium", "Glass polishing, catalysts", 5000, true));
        tradeItems.push(RareEarth("Lanthanum", "Battery alloys", 6000, true));
        tradeItems.push(RareEarth("Samarium", "Nuclear reactors", 12000, true));
        tradeItems.push(RareEarth("Yttrium", "Semiconductors, lasers", 15000, true));
    }

    function proposeTrade(string memory element, string memory useCase, uint256 valueUSD, bool damayClause) public {
        require(msg.sender == stewardPH || msg.sender == stewardIN, "Unauthorized steward");
        tradeItems.push(RareEarth(element, useCase, valueUSD, damayClause));
    }

    function getTradeItem(uint index) public view returns (string memory, string memory, uint256, bool) {
        RareEarth memory item = tradeItems[index];
        return (item.element, item.useCase, item.estimatedValueUSD, item.damayClause);
    }
}
