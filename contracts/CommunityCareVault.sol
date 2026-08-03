// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CommunityCareVault
 * @notice A decentralized peer-support fund focused on mental resilience and community welfare.
 * @dev Allows verified community members to pool resources and collectively approve care grants.
 */
contract CommunityCareVault {
    
    address public immutable chiefSteward;
    uint256 public totalCareFunds;
    uint256 public requestCounter;

    struct CareRequest {
        uint256 id;
        address applicant;
        string encryptedNeedDescription; // Encrypted for privacy/stigma reduction
        uint256 requestedAmount;
        uint256 approvals;
        bool isFulfilled;
    }

    mapping(address => bool) public verifiedPeers;
    mapping(uint256 => CareRequest) public careRequests;
    mapping(uint256 => mapping(address => bool)) public hasApproved;

    event VaultFunded(address indexed donor, uint256 amount);
    event PeerVerified(address indexed peer);
    event CareRequestSubmitted(uint256 indexed requestId, address indexed applicant, uint256 amount);
    event CareRequestFulfilled(uint256 indexed requestId, address indexed applicant, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == chiefSteward, "Unauthorized: Only the Chief Steward can perform this.");
        _;
    }

    modifier onlyVerifiedPeer() {
        require(verifiedPeers[msg.sender], "Unauthorized: Must be a verified peer to access the vault.");
        _;
    }

    constructor() {
        chiefSteward = msg.sender;
        verifiedPeers[msg.sender] = true; // The creator is the first verified peer
    }

    /**
     * @notice Allows anyone to donate funds to the Community Care Vault.
     */
    function fundVault() external payable {
        require(msg.value > 0, "Donation must be greater than zero.");
        totalCareFunds += msg.value;
        emit VaultFunded(msg.sender, msg.value);
    }

    /**
     * @notice Adds a trusted member to the peer support network.
     */
    function verifyPeer(address _peer) external onlySteward {
        require(!verifiedPeers[_peer], "Peer is already verified.");
        verifiedPeers[_peer] = true;
        emit PeerVerified(_peer);
    }

    /**
     * @notice Submits a request for support. The description should be IPFS hash or encrypted string for privacy.
     */
    function submitCareRequest(string calldata _encryptedNeed, uint256 _amount) external onlyVerifiedPeer {
        require(_amount > 0 && _amount <= totalCareFunds, "Invalid amount or insufficient vault funds.");
        
        requestCounter++;
        careRequests[requestCounter] = CareRequest({
            id: requestCounter,
            applicant: msg.sender,
            encryptedNeedDescription: _encryptedNeed,
            requestedAmount: _amount,
            approvals: 0,
            isFulfilled: false
        });

        emit CareRequestSubmitted(requestCounter, msg.sender, _amount);
    }

    /**
     * @notice Peers approve requests. Requires 3 approvals (or a dynamic threshold in production) to release funds.
     */
    function approveAndFulfillRequest(uint256 _requestId) external onlyVerifiedPeer {
        CareRequest storage request = careRequests[_requestId];
        require(!request.isFulfilled, "Request is already fulfilled.");
        require(!hasApproved[_requestId][msg.sender], "You have already approved this request.");
        require(request.applicant != msg.sender, "You cannot approve your own request.");

        hasApproved[_requestId][msg.sender] = true;
        request.approvals++;

        // Threshold for collective empathy: 2 peers need to approve to release the care fund
        if (request.approvals >= 2) {
            require(address(this).balance >= request.requestedAmount, "Insufficient vault balance.");
            
            request.isFulfilled = true;
            totalCareFunds -= request.requestedAmount;
            
            (bool success, ) = payable(request.applicant).call{value: request.requestedAmount}("");
            require(success, "Fund transfer failed.");

            emit CareRequestFulfilled(_requestId, request.applicant, request.requestedAmount);
        }
    }
}
