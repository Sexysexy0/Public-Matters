// TransportSafeguards.sol
pragma solidity ^0.8.0;

contract TransportSafeguards {
    struct Safeguard {
        uint256 id;
        string principle;   // e.g. "Driver Livelihood Protection"
        string measure;     // e.g. "Mandate zero or low membership fees, prohibit exploitative dues, protect dignity in driver income"
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
