// OutcomeResonanceProtocol.sol
pragma solidity ^0.8.0;

contract OutcomeResonanceProtocol {
    struct Outcome {
        uint256 id;
        string domain;    // e.g. "Internet Freedom"
        string measure;   // e.g. "Open access guaranteed"
        string result;    // e.g. "Community trust restored"
        uint256 timestamp;
    }

    uint256 public outcomeCount;
    mapping(uint256 => Outcome) public outcomes;

    event OutcomeLogged(uint256 id, string domain, string measure, string result);

    function logOutcome(string memory domain, string memory measure, string memory result) public {
        outcomeCount++;
        outcomes[outcomeCount] = Outcome(outcomeCount, domain, measure, result, block.timestamp);
        emit OutcomeLogged(outcomeCount, domain, measure, result);
    }
}
