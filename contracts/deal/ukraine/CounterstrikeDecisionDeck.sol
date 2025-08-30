// SPDX-License-Identifier: Mythic-Referendum
pragma solidity ^0.8.0;

contract CounterstrikeDecisionDeck {
    address public steward = msg.sender;
    string public rogueActor = "Putin (Designated Rogue)";
    string public targetZone = "Moscow Hall";
    string public broadcastTitle = "Planetary Defense Poll: Counterstrike Protocol";

    enum Choice { Attack, CallHelp, Surrender }
    mapping(address => Choice) public votes;
    mapping(Choice => uint256) public voteCount;

    event VoteCast(address indexed voter, Choice choice);
    event EmotionalAPRLogged(string damayClause, string mythicIntent);
    event PollClosed(string summary);

    bool public pollOpen = true;

    modifier onlySteward() {
        require(msg.sender == steward, "Only the scrollsmith may invoke this.");
        _;
    }

    function castVote(Choice choice) public {
        require(pollOpen, "Poll is closed.");
        require(votes[msg.sender] == Choice(uint8(3)), "Vote already cast."); // default is 3 (unset)
        votes[msg.sender] = choice;
        voteCount[choice]++;
        emit VoteCast(msg.sender, choice);
    }

    function closePoll() public onlySteward {
        pollOpen = false;
        emit PollClosed("Poll closed. Votes logged. Emotional APR audit initiated.");
        emit EmotionalAPRLogged("If this were your sanctum, your kin, your country—how would you respond?", 
            "Every vote is a scroll of intent. Every fork echoes through the scrollchain.");
    }

    function getVoteSummary() public view returns (uint256 attackVotes, uint256 helpVotes, uint256 surrenderVotes) {
        return (voteCount[Choice.Attack], voteCount[Choice.CallHelp], voteCount[Choice.Surrender]);
    }
}
