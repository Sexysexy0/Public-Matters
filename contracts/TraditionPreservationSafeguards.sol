// TraditionPreservationSafeguards.sol
pragma solidity ^0.8.0;

contract TraditionPreservationSafeguards {
    struct Heritage {
        uint256 id;
        string tradition;   // e.g. "Bayanihan"
        string safeguard;   // e.g. "Protect from distortion"
        uint256 timestamp;
    }

    uint256 public heritageCount;
    mapping(uint256 => Heritage) public heritages;

    event HeritageLogged(uint256 id, string tradition, string safeguard);

    function logHeritage(string memory tradition, string memory safeguard) public {
        heritageCount++;
        heritages[heritageCount] = Heritage(heritageCount, tradition, safeguard, block.timestamp);
        emit HeritageLogged(heritageCount, tradition, safeguard);
    }
}
