// ImpactResonanceProtocol.sol
pragma solidity ^0.8.0;

contract ImpactResonanceProtocol {
    struct Effect {
        uint256 id;
        string domain;    // e.g. "Community Development"
        string measure;   // e.g. "Scholarship program"
        string outcome;   // e.g. "Improved education access"
        uint256 timestamp;
    }

    uint256 public effectCount;
    mapping(uint256 => Effect) public effects;

    event EffectLogged(uint256 id, string domain, string measure, string outcome);

    function logEffect(string memory domain, string memory measure, string memory outcome) public {
        effectCount++;
        effects[effectCount] = Effect(effectCount, domain, measure, outcome, block.timestamp);
        emit EffectLogged(effectCount, domain, measure, outcome);
    }
}
