// Tags lagging altcoins with rally potential and civic use cases
pragma solidity ^0.8.19;

contract AltcoinCatchUpProtocol {
    struct Altcoin {
        string name;
        bool isLagging;
        string civicUseCase;
    }

    Altcoin[] public altcoins;

    function tagAltcoin(string memory name, bool lagging, string memory useCase) public {
        altcoins.push(Altcoin(name, lagging, useCase));
    }

    function getTaggedAltcoins() public view returns (Altcoin[] memory) {
        return altcoins;
    }
}
