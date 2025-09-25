// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title TylenolClaimReversalProtocol
/// @notice Ritualizes the reversal of the false Tylenol–autism claim
/// @dev Anchors emotional consequence, scientific integrity, and health dignity restoration

contract TylenolClaimReversalProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyValidator() {
        require(validators[msg.sender] || msg.sender == steward, "Not validator");
        _;
    }

    struct ClaimReversal {
        uint256 id;
        string claim; // e.g., "Tylenol causes autism"
        string reversalBasis; // e.g., "No causal link confirmed by WHO, FDA, JAMA"
        string emotionalTag; // e.g., "Medical dignity restored"
        string apologyClause; // e.g., "We regret the spread of unverified health claims"
        uint256 timestamp;
    }

    uint256 public nextReversalId = 1;
    mapping(uint256 => ClaimReversal) public reversals;

    event ValidatorSet(address indexed account, bool status);
    event ClaimReversed(uint256 indexed id, string claim, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function reverseClaim(
        string calldata claim,
        string calldata reversalBasis,
        string calldata emotionalTag,
        string calldata apologyClause
    ) external onlyValidator returns (uint256 id) {
        id = nextReversalId++;
        reversals[id] = ClaimReversal({
            id: id,
            claim: claim,
            reversalBasis: reversalBasis,
            emotionalTag: emotionalTag,
            apologyClause: apologyClause,
            timestamp: block.timestamp
        });
        emit ClaimReversed(id, claim, emotionalTag);
    }

    function getReversal(uint256 id) external view returns (ClaimReversal memory) {
        return reversals[id];
    }
}
