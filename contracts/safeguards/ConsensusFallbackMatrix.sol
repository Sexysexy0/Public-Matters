// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ConsensusFallbackMatrix
/// @notice Safeguard contract to maintain system state integrity during network degradation, managing fallback validation checkpoints
contract ConsensusFallbackMatrix {
    event PeerStatusUpdated(address indexed peerNode, bool isCleared, uint256 trustWeight);
    event FallbackCheckpointLogged(uint256 indexed checkpointId, bytes32 stateRootHash, uint256 activeValidatorsCount);
    event DegradedModeTriggered(string alertType, uint256 currentOnlinePeers);
    event GovernanceAuthorityTransferred(address indexed oldGovernor, address indexed newGovernor);

    address public matrixGovernor;
    bool public fallbackMatrixActive;
    uint256 public constant MIN_ONLINE_PEERS_REQUIRED = 3;

    struct PeerNodeProfile {
        uint256 trustWeight; // Scale of 1 to 100
        uint256 lastSeenBlock;
        bool isCleared;
        bool registered;
    }

    struct CheckpointRecord {
        bytes32 stateRootHash;
        uint256 recordedAtBlock;
        uint256 validationSignaturesCount;
        bool permanentCommitExecuted;
    }

    // Mapping from node address to peer clearance profiles
    mapping(address => PeerNodeProfile) public peerRegistry;
    // Mapping from unique sequential ID to fallback checkpoint metadata
    mapping(uint256 => CheckpointRecord) public checkpointRegistry;
    
    uint256 public totalRegisteredPeers;
    uint256 public totalActiveOnlinePeers;
    uint256 public currentCheckpointCounter;

    constructor() {
        matrixGovernor = msg.sender;
        fallbackMatrixActive = false;
    }

    modifier onlyGovernor() {
        require(msg.sender == matrixGovernor, "Unauthorized: Matrix Governor verification failed");
        _;
    }

    modifier onlyClearedPeer() {
        require(peerRegistry[msg.sender].isCleared, "Access Denied: Node lacks baseline peer clearance credentials");
        _;
    }

    /// @notice Register and clear an official fallback node or infrastructure validation peer
    function enrollPeerNode(address _peer, uint256 _weight) external onlyGovernor {
        require(_peer != address(0), "Invalid tracking node coordinate input parameters");
        require(!peerRegistry[_peer].registered, "Peer node profile already active in matrix registry");
        require(_weight <= 100, "Weight parameter exceeds absolute maximum allowable index");

        peerRegistry[_peer] = PeerNodeProfile({
            trustWeight: _weight,
            lastSeenBlock: block.number,
            isCleared: true,
            registered: true
        });

        totalRegisteredPeers += 1;
        totalActiveOnlinePeers += 1;
        
        emit PeerStatusUpdated(_peer, true, _weight);
    }

    /// @notice Update tracking heartbeat parameters for network telemetry consensus nodes
    function submitPeerHeartbeat() external onlyClearedPeer {
        PeerNodeProfile storage peer = peerRegistry[msg.sender];
        peer.lastSeenBlock = block.number;
    }

    /// @notice Commit an emergency baseline snapshot configuration checkpoint to prevent state drift during degradation
    /// @param _rootHash Cryptographic state fingerprint trace identifier
    /// @param _signaturesCount Evaluated validator or peer signatures attached to the telemetry update
    function commitFallbackCheckpoint(bytes32 _rootHash, uint256 _signaturesCount) external onlyClearedPeer {
        require(_rootHash != bytes32(0), "Invalid state root hash parameter configuration");
        
        // Dynamic Evaluation: Automatically check if online validation mesh drops below secure baseline limits
        if (totalActiveOnlinePeers < MIN_ONLINE_PEERS_REQUIRED && !fallbackMatrixActive) {
            fallbackMatrixActive = true;
            emit DegradedModeTriggered("Infrastructure Degradation: Peer count below secure threshold limits", totalActiveOnlinePeers);
        }

        currentCheckpointCounter += 1;
        checkpointRegistry[currentCheckpointCounter] = CheckpointRecord({
            stateRootHash: _rootHash,
            recordedAtBlock: block.number,
            validationSignaturesCount: _signaturesCount,
            permanentCommitExecuted: true
        });

        emit FallbackCheckpointLogged(currentCheckpointCounter, _rootHash, _signaturesCount);
    }

    /// @notice Update or isolate a peer's structural clearance status directly based on telemetry anomalies
    function modifyPeerClearance(address _peer, bool _status) external onlyGovernor {
        require(peerRegistry[_peer].registered, "Target peer configuration profile does not exist");
        
        if (peerRegistry[_peer].isCleared && !_status) {
            if (totalActiveOnlinePeers > 0) totalActiveOnlinePeers -= 1;
        } else if (!peerRegistry[_peer].isCleared && _status) {
            totalActiveOnlinePeers += 1;
        }

        peerRegistry[_peer].isCleared = _status;
        emit PeerStatusUpdated(_peer, _status, peerRegistry[_peer].trustWeight);
    }

    /// @notice Manually disengage or toggle the active system wide fallback mode controls
    function setFallbackMatrixMode(bool _modeActive) external onlyGovernor {
        fallbackMatrixActive = _modeActive;
    }

    /// @notice Migrate the central matrix governance block to an updated structural coordinator node
    function transferMatrixManagement(address _newGovernor) external onlyGovernor {
        require(_newGovernor != address(0), "Invalid target network deployment coordinate parameters");
        emit GovernanceAuthorityTransferred(matrixGovernor, _newGovernor);
        matrixGovernor = _newGovernor;
    }
}
