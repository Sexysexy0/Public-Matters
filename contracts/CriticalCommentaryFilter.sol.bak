// CriticalCommentaryFilter.sol
pragma solidity ^0.8.0;

contract CriticalCommentaryFilter {
    struct Claim {
        uint256 id;
        string source;     // e.g. "Financial Times"
        string status;     // e.g. "Verified" or "Unverified"
        uint256 timestamp;
    }

    uint256 public claimCount;
    mapping(uint256 => Claim) public claims;

    event ClaimLogged(uint256 id, string source, string status);

    function logClaim(string memory source, string memory status) public {
        claimCount++;
        claims[claimCount] = Claim(claimCount, source, status, block.timestamp);
        emit ClaimLogged(claimCount, source, status);
    }
}
