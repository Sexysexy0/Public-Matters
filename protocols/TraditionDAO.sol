// TraditionDAO.sol
pragma solidity ^0.8.0;

contract TraditionDAO {
    struct Value {
        uint256 id;
        string theme;    // e.g. "Faith"
        string detail;   // e.g. "Original Scout Oath focus"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public valueCount;
    mapping(uint256 => Value) public values;

    event ValueCreated(uint256 id, string theme, string detail);
    event ValueVoted(uint256 id, string theme, bool support);
    event ValueRatified(uint256 id, string theme);
    event TraditionDeclared(string message);

    function createValue(string memory theme, string memory detail) public {
        valueCount++;
        values[valueCount] = Value(valueCount, theme, detail, 0, 0, false);
        emit ValueCreated(valueCount, theme, detail);
    }

    function voteValue(uint256 id, bool support) public {
        if (support) {
            values[id].votesFor++;
        } else {
            values[id].votesAgainst++;
        }
        emit ValueVoted(id, values[id].theme, support);
    }

    function ratifyValue(uint256 id) public {
        Value storage v = values[id];
        require(!v.ratified, "Already ratified");
        require(v.votesFor > v.votesAgainst, "Not enough support");
        v.ratified = true;
        emit ValueRatified(v.id, v.theme);
    }

    function declareTradition() public {
        emit TraditionDeclared("Tradition DAO: safeguard arcs encoded into communal consequence.");
    }
}
