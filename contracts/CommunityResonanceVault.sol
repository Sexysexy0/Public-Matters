// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityResonanceVault {
    struct Suggestion {
        address participant;
        string idea;
        uint256 timestamp;
        bool safeguarded;
    }

    Suggestion[] public suggestions;

    event SuggestionLogged(address indexed participant, string idea);
    event SuggestionSafeguarded(uint256 indexed id, address verifier);

    function logSuggestion(string memory _idea) public {
        suggestions.push(Suggestion(msg.sender, _idea, block.timestamp, false));
        emit SuggestionLogged(msg.sender, _idea);
    }

    function safeguardSuggestion(uint256 _id) public {
        require(_id < suggestions.length, "Invalid ID");
        suggestions[_id].safeguarded = true;
        emit SuggestionSafeguarded(_id, msg.sender);
    }

    function getSuggestion(uint256 _id) public view returns (Suggestion memory) {
        require(_id < suggestions.length, "Invalid ID");
        return suggestions[_id];
    }

    function totalSuggestions() public view returns (uint256) {
        return suggestions.length;
    }
}
