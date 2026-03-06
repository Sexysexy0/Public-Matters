// CivilLibertiesSafeguards.sol
pragma solidity ^0.8.0;

contract CivilLibertiesSafeguards {
    struct Safeguard {
        uint256 id;
        string liberty;    // e.g. "Freedom of Speech"
        string measure;    // e.g. "Protect civil liberties and privacy"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string liberty, string measure);

    function logSafeguard(string memory liberty, string memory measure) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, liberty, measure, block.timestamp);
        emit SafeguardLogged(safeguardCount, liberty, measure);
    }
}
