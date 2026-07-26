pragma solidity ^0.8.0;

contract HarmonyResonanceProtocol {
    struct Suggestion {
        uint256 id;
        string partner;
        string idea;
        string outcome;
        uint256 timestamp;
    }

    uint256 public suggestionCount;
    mapping(uint256 => Suggestion) public suggestions;

    event SuggestionLogged(uint256 id, string partner, string idea, string outcome);

    function logSuggestion(string memory partner, string memory idea, string memory outcome) public {
        suggestionCount++;
        suggestions[suggestionCount] = Suggestion(suggestionCount, partner, idea, outcome, block.timestamp);
        emit SuggestionLogged(suggestionCount, partner, idea, outcome);
    }
}
