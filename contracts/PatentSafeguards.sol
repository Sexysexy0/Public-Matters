// PatentSafeguards.sol
pragma solidity ^0.8.0;

contract PatentSafeguards {
    struct Safeguard {
        uint256 id;
        string principle;   // e.g. "Fair Competition"
        string measure;     // e.g. "Reject overly broad patents, safeguard against chilling effect in monster-catching genre"
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
