// FarmerSafeguards.sol
pragma solidity ^0.8.0;

contract FarmerSafeguards {
    struct Safeguard {
        uint256 id;
        string mechanism;  // e.g. "Fair Crop Pricing Policy"
        string measure;    // e.g. "Protect farmers from exploitation and unstable markets"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string mechanism, string measure);

    function logSafeguard(string memory mechanism, string memory measure) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, mechanism, measure, block.timestamp);
        emit SafeguardLogged(safeguardCount, mechanism, measure);
    }
}
