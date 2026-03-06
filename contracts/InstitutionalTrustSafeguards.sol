// InstitutionalTrustSafeguards.sol
pragma solidity ^0.8.0;

contract InstitutionalTrustSafeguards {
    struct Safeguard {
        uint256 id;
        string institution; // e.g. "Congress"
        string measure;     // e.g. "Transparency reforms"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string institution, string measure);

    function logSafeguard(string memory institution, string memory measure) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, institution, measure, block.timestamp);
        emit SafeguardLogged(safeguardCount, institution, measure);
    }
}
