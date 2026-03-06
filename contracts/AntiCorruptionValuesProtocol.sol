// AntiCorruptionValuesProtocol.sol
pragma solidity ^0.8.0;

contract AntiCorruptionValuesProtocol {
    struct Safeguard {
        uint256 id;
        string symbol;     // e.g. "National Flag"
        string protection; // e.g. "Guard against manipulation"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string symbol, string protection);

    function logSafeguard(string memory symbol, string memory protection) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, symbol, protection, block.timestamp);
        emit SafeguardLogged(safeguardCount, symbol, protection);
    }
}
