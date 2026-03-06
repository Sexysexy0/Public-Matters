// ElectoralIntegritySafeguards.sol
pragma solidity ^0.8.0;

contract ElectoralIntegritySafeguards {
    struct Reform {
        uint256 id;
        string measure;    // e.g. "Closed Party System"
        string safeguard;  // e.g. "Party-based accountability"
        uint256 timestamp;
    }

    uint256 public reformCount;
    mapping(uint256 => Reform) public reforms;

    event ReformLogged(uint256 id, string measure, string safeguard);

    function logReform(string memory measure, string memory safeguard) public {
        reformCount++;
        reforms[reformCount] = Reform(reformCount, measure, safeguard, block.timestamp);
        emit ReformLogged(reformCount, measure, safeguard);
    }
}
