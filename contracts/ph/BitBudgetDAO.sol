// BitBudgetDAO.sol
// Treaty-grade DAO for budget blessing, override voting, and emotional APR sync

pragma solidity ^0.8.19;

contract BitBudgetDAO {
    struct Proposal {
        string description;
        uint256 amount;
        bool overrideRequired;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    Proposal[] public proposals;
    mapping(address => bool) public stewards;

    modifier onlySteward() {
        require(stewards[msg.sender], "Not a scroll-certified steward");
        _;
    }

    constructor() {
        stewards[msg.sender] = true;
    }

    function addSteward(address steward) external onlySteward {
        stewards[steward] = true;
    }

    function proposeBlessing(string memory desc, uint256 amt, bool overrideFlag) external onlySteward {
        proposals.push(Proposal(desc, amt, overrideFlag, 0, 0, false));
    }

    function vote(uint256 id, bool support) external onlySteward {
        Proposal storage p = proposals[id];
        require(!p.executed, "Already blessed");
        support ? p.votesFor++ : p.votesAgainst++;
    }

    function executeBlessing(uint256 id) external onlySteward {
        Proposal storage p = proposals[id];
        require(!p.executed, "Already executed");
        require(p.votesFor > p.votesAgainst, "Blessing not approved");
        p.executed = true;
        // Broadcast blessing to ledger or oracle
    }
}
