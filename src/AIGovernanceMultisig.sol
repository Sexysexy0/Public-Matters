// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AIGovernanceMultisig
 * @notice N-of-M multisig for critical AI governance actions.
 *         Prevents single-key compromise from taking over the stack.
 */
contract AIGovernanceMultisig {
    OperatorPrivileges public privileges;

    struct Proposal {
        uint256 id;
        address proposer;
        address target;
        uint256 value;
        bytes data;
        uint256 createdAt;
        uint256 expiresAt;
        uint256 approvals;
        bool executed;
        bool cancelled;
        string description;
    }

    uint256 public threshold;
    uint256 public proposalLifetime = 7 days;
    uint256 public proposalCount;

    mapping(uint256 => Proposal) internal _proposals;
    mapping(uint256 => mapping(address => bool)) public hasApproved;
    address[] public signers;
    mapping(address => bool) public isSigner;

    event ProposalCreated(uint256 indexed id, address indexed proposer, address target, uint256 value, string description);
    event ProposalApproved(uint256 indexed id, address indexed signer, uint256 approvals);
    event ProposalExecuted(uint256 indexed id, address indexed executor);
    event ProposalCancelled(uint256 indexed id, address indexed canceller);
    event ThresholdChanged(uint256 oldThreshold, uint256 newThreshold);
    event SignerAdded(address indexed signer);
    event SignerRemoved(address indexed signer);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    modifier onlySigner() {
        require(isSigner[msg.sender], "Not a signer");
        _;
    }

    constructor(address _privileges, address[] memory _signers, uint256 _threshold) {
        require(_privileges != address(0), "Invalid privileges");
        require(_signers.length > 0, "Need signers");
        require(_threshold > 0 && _threshold <= _signers.length, "Invalid threshold");

        privileges = OperatorPrivileges(_privileges);
        threshold = _threshold;

        for (uint256 i = 0; i < _signers.length; i++) {
            require(_signers[i] != address(0), "Invalid signer");
            require(!isSigner[_signers[i]], "Duplicate signer");
            isSigner[_signers[i]] = true;
            signers.push(_signers[i]);
        }
    }

    function createProposal(
        address target,
        uint256 value,
        bytes calldata data,
        string calldata description
    ) external onlySigner returns (uint256) {
        require(target != address(0), "Invalid target");

        proposalCount++;
        _proposals[proposalCount] = Proposal({
            id: proposalCount,
            proposer: msg.sender,
            target: target,
            value: value,
            data: data,
            createdAt: block.timestamp,
            expiresAt: block.timestamp + proposalLifetime,
            approvals: 0,
            executed: false,
            cancelled: false,
            description: description
        });

        emit ProposalCreated(proposalCount, msg.sender, target, value, description);
        return proposalCount;
    }

    function approve(uint256 proposalId) external onlySigner {
        Proposal storage p = _proposals[proposalId];
        require(p.id != 0, "Proposal not found");
        require(!p.executed, "Already executed");
        require(!p.cancelled, "Cancelled");
        require(block.timestamp <= p.expiresAt, "Expired");
        require(!hasApproved[proposalId][msg.sender], "Already approved");

        hasApproved[proposalId][msg.sender] = true;
        p.approvals++;

        emit ProposalApproved(proposalId, msg.sender, p.approvals);

        if (p.approvals >= threshold) {
            _execute(proposalId);
        }
    }

    function _execute(uint256 proposalId) internal {
        Proposal storage p = _proposals[proposalId];
        p.executed = true;

        (bool success, ) = p.target.call{value: p.value}(p.data);
        require(success, "Execution failed");

        emit ProposalExecuted(proposalId, msg.sender);
    }

    function cancelProposal(uint256 proposalId) external onlySigner {
        Proposal storage p = _proposals[proposalId];
        require(p.id != 0, "Proposal not found");
        require(!p.executed, "Already executed");
        require(!p.cancelled, "Already cancelled");

        p.cancelled = true;
        emit ProposalCancelled(proposalId, msg.sender);
    }

    function addSigner(address signer) external onlyOperator {
        require(signer != address(0), "Invalid signer");
        require(!isSigner[signer], "Already signer");
        isSigner[signer] = true;
        signers.push(signer);
        emit SignerAdded(signer);
    }

    function removeSigner(address signer) external onlyOperator {
        require(isSigner[signer], "Not a signer");
        isSigner[signer] = false;

        for (uint256 i = 0; i < signers.length; i++) {
            if (signers[i] == signer) {
                signers[i] = signers[signers.length - 1];
                signers.pop();
                break;
            }
        }
        emit SignerRemoved(signer);
    }

    function setThreshold(uint256 newThreshold) external onlyOperator {
        require(newThreshold > 0 && newThreshold <= signers.length, "Invalid threshold");
        uint256 old = threshold;
        threshold = newThreshold;
        emit ThresholdChanged(old, newThreshold);
    }

    function setProposalLifetime(uint256 newLifetime) external onlyOperator {
        require(newLifetime > 0, "Invalid lifetime");
        proposalLifetime = newLifetime;
    }

    function getProposal(uint256 proposalId) external view returns (Proposal memory) {
        return _proposals[proposalId];
    }

    function getSigners() external view returns (address[] memory) {
        return signers;
    }

    function signerCount() external view returns (uint256) {
        return signers.length;
    }
}
