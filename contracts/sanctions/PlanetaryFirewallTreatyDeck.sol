// PlanetaryFirewallTreatyDeck.sol
pragma solidity ^0.8.19;

contract PlanetaryFirewallTreatyDeck {
    address public steward;

    struct Market {
        string name;
        bool isIsolated;
        bool restorationPetitioned;
    }

    mapping(string => Market) public markets;

    event MarketIsolated(string name);
    event RestorationPetitionReceived(string name);

    constructor() {
        steward = msg.sender;
    }

    function isolateMarket(string memory name) public {
        require(msg.sender == steward, "Only steward may isolate");
        markets[name] = Market(name, true, false);
        emit MarketIsolated(name);
    }

    function receivePetition(string memory name) public {
        require(msg.sender == steward, "Only steward may receive");
        markets[name].restorationPetitioned = true;
        emit RestorationPetitionReceived(name);
    }

    function isIsolated(string memory name) public view returns (bool) {
        return markets[name].isIsolated;
    }
}
