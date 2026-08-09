import "./ITrustIntegrator.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


/**
 * @title PermissionlessBroadcast
 * @dev A community archive of hope. Anyone can submit; the steward curates.
 *      Automatically updates the Trust Index when a message is approved.
 */
contract PermissionlessBroadcast {
    address public immutable steward;
    ITrustIntegrator public trustIntegrator;

    struct Submission {
        address author;
        string message;
        uint256 timestamp;
        bool approved;
    }

    Submission[] public submissions;
    uint256 public approvedCount;

    event SubmissionReceived(address indexed author, string message, uint256 timestamp);
    event SubmissionApproved(uint256 indexed id, address indexed author, string message);
    event TrustIntegratorUpdated(address newIntegrator);

    modifier onlySteward() {
        require(msg.sender == steward, "Only the steward");
        _;
    }

    constructor(address _trustIntegrator) {
        steward = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    // Anyone can submit a message of hope or gratitude
    function submitMessage(string memory _message) external {
        require(bytes(_message).length > 0, "Message cannot be empty");
        submissions.push(Submission({
            author: msg.sender,
            message: _message,
            timestamp: block.timestamp,
            approved: false
        }));
        emit SubmissionReceived(msg.sender, _message, block.timestamp);
    }

    // Steward approves a submission to be permanently stored
    function approveSubmission(uint256 _index) external onlySteward {
        require(_index < submissions.length, "Submission does not exist");
        require(!submissions[_index].approved, "Already approved");

        submissions[_index].approved = true;
        approvedCount++;

        // Automatically bump the Trust Index
        trustIntegrator.logPositiveAction(10);

        emit SubmissionApproved(_index, submissions[_index].author, submissions[_index].message);
    }

    function setTrustIntegrator(address _newIntegrator) external onlySteward {
        trustIntegrator = ITrustIntegrator(_newIntegrator);
        emit TrustIntegratorUpdated(_newIntegrator);
    }

    // Get all submissions (approved and pending)
    function getAllSubmissions() external view returns (Submission[] memory) {
        return submissions;
    }

    // Get only approved messages (the public archive)
    function getApprovedMessages() external view returns (Submission[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < submissions.length; i++) {
            if (submissions[i].approved) count++;
        }

        Submission[] memory approved = new Submission[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < submissions.length; i++) {
            if (submissions[i].approved) {
                approved[index] = submissions[i];
                index++;
            }
        }
        return approved;
    }

    function getSubmissionCount() external view returns (uint256) {
        return submissions.length;
    }
}
