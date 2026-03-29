// ProtestFundingSafeguards.sol
pragma solidity ^0.8.0;

contract ProtestFundingSafeguards {
    struct Safeguard {
        uint256 id;
        string principle;   // e.g. "Ensure Transparency in Protest Funding"
        string measure;     // e.g. "Mandate disclosure of funding sources and prohibit undisclosed foreign contributions"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string principle, string measure);

    function logSafeguard(string memory principle, string memory measure) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, principle, measure, block.timestamp);
        emit SafeguardLogged(safeguardCount, principle, measure);
    }
}
