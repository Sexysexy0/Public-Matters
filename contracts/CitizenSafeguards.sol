// CitizenSafeguards.sol
pragma solidity ^0.8.0;

contract CitizenSafeguards {
    struct Safeguard {
        uint256 id;
        string right;      // e.g. "Right to Participate"
        string measure;    // e.g. "Protect rights and responsibilities in governance"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string right, string measure);

    function logSafeguard(string memory right, string memory measure) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, right, measure, block.timestamp);
        emit SafeguardLogged(safeguardCount, right, measure);
    }
}
