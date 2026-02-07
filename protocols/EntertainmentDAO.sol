// EntertainmentDAO.sol
pragma solidity ^0.8.0;

contract EntertainmentDAO {
    struct Option {
        uint256 id;
        string type;   // e.g. "Music", "Video", "Games"
        string feedback; // e.g. "Enjoyed", "Skipped"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public optionCount;
    mapping(uint256 => Option) public options;

    event OptionCreated(uint256 id, string type, string feedback);
    event OptionVoted(uint256 id, string type, bool support);
    event OptionPublished(uint256 id, string type);
    event EntertainmentDeclared(string message);

    function createOption(string memory type, string memory feedback) public {
        optionCount++;
        options[optionCount] = Option(optionCount, type, feedback, 0, 0, false);
        emit OptionCreated(optionCount, type, feedback);
    }

    function voteOption(uint256 id, bool support) public {
        if (support) {
            options[id].votesFor++;
        } else {
            options[id].votesAgainst++;
        }
        emit OptionVoted(id, options[id].type, support);
    }

    function publishOption(uint256 id) public {
        Option storage o = options[id];
        require(!o.published, "Already published");
        require(o.votesFor > o.votesAgainst, "Not enough support");
        o.published = true;
        emit OptionPublished(o.id, o.type);
    }

    function declareEntertainment() public {
        emit EntertainmentDeclared("Entertainment DAO: safeguard arcs encoded into communal consequence.");
    }
}
