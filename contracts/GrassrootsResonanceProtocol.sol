// GrassrootsResonanceProtocol.sol
pragma solidity ^0.8.0;

contract GrassrootsResonanceProtocol {
    struct Safeguard {
        uint256 id;
        string reform;    // e.g. "Education Reform"
        string need;      // e.g. "Accessible for rural communities"
        string outcome;   // e.g. "Policy aligned with grassroots needs"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string reform, string need, string outcome);

    function logSafeguard(string memory reform, string memory need, string memory outcome) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, reform, need, outcome, block.timestamp);
        emit SafeguardLogged(safeguardCount, reform, need, outcome);
    }
}
