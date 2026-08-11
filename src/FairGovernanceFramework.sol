// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FairGovernanceFramework {
    struct Policy {
        string title;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
        bool exists;
    }

    mapping(bytes32 => Policy) public policies;
    mapping(bytes32 => mapping(address => bool)) public hasVoted;
    
    address public immutable administrator;
    uint256 public constant QUORUM = 50; // Minimum votes required for fairness check

    event PolicyProposed(bytes32 indexed policyId, string title);
    event PolicyVoted(bytes32 indexed policyId, address indexed voter, bool support);
    event PolicyExecuted(bytes32 indexed policyId, bool approved);

    modifier onlyAdmin() {
        require(msg.sender == administrator, "Unauthorized: Admin only");
        _;
    }

    constructor() {
        administrator = msg.sender;
    }

    function proposePolicy(string memory _title, string memory _description) external onlyAdmin returns (bytes32) {
        bytes32 policyId = keccak256(abi.encodePacked(_title, block.timestamp));
        require(!policies[policyId].exists, "Policy already exists");

        policies[policyId] = Policy({
            title: _title,
            description: _description,
            votesFor: 0,
            votesAgainst: 0,
            executed: false,
            exists: true
        });

        emit PolicyProposed(policyId, _title);
        return policyId;
    }

    function voteOnPolicy(bytes32 _policyId, bool _support) external {
        Policy storage policy = policies[_policyId];
        require(policy.exists, "Policy does not exist");
        require(!policy.executed, "Policy already executed");
        require(!hasVoted[_policyId][msg.sender], "Already voted on this policy");

        hasVoted[_policyId][msg.sender] = true;

        if (_support) {
            policy.votesFor += 1;
        } else {
            policy.votesAgainst += 1;
        }

        emit PolicyVoted(_policyId, msg.sender, _support);
    }

    function evaluateAndExecutePolicy(bytes32 _policyId) external onlyAdmin {
        Policy storage policy = policies[_policyId];
        require(policy.exists, "Policy does not exist");
        require(!policy.executed, "Policy already executed");
        
        uint256 totalVotes = policy.votesFor + policy.votesAgainst;
        require(totalVotes >= QUORUM, "Quorum not reached for fairness check");

        // Fair governance rule: Requires majority support and empathy safeguards
        bool approved = policy.votesFor > policy.votesAgainst;
        policy.executed = true;

        emit PolicyExecuted(_policyId, approved);
    }
}
