// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ComputationalIntegrityOracle
/// @notice Safeguard contract to verify decentralized computation outputs, track execution proofs, and enforce compute node accountability
contract ComputationalIntegrityOracle {
    event ComputeJobLogged(bytes32 indexed jobId, address indexed executionNode, bytes32 inputStateHash);
    event ProofVerified(bytes32 indexed jobId, bytes32 indexed executionProofHash, bool indexed isValid);
    event ComputationalFaultFlagged(address indexed maliciousNode, bytes32 indexed jobId, string errorType);
    event IntegrityAuthorityTransferred(address indexed oldSteward, address indexed newSteward);

    address public integritySteward;
    bool public strictProofValidationActive;
    uint256 public constant MIN_TRUST_SCORE = 70; // Trust threshold on a scale of 1 to 100

    struct ComputeJob {
        address computationNode;
        bytes32 inputStateHash;
        bytes32 validatedOutputHash;
        bool statusFinalized;
        bool executionVerified;
        uint256 submittedAtBlock;
    }

    struct NodeMetrics {
        uint256 totalJobsExecuted;
        uint256 successfulProofs;
        uint256 trustScore; // Out of 100
        bool isRegistered;
    }

    // Mapping from unique job tracking hash to computational execution profiles
    mapping(bytes32 => ComputeJob) public computeJobsRegistry;
    // Mapping from node address to active hardware trust metrics
    mapping(address => NodeMetrics) public computeNodes;

    constructor() {
        integritySteward = msg.sender;
        strictProofValidationActive = true;
    }

    modifier onlySteward() {
        require(msg.sender == integritySteward, "Unauthorized: Integrity Steward signature check failed");
        _;
    }

    /// @notice Register an authorized decentralized hardware computation node
    function registerComputeNode(address _node) external onlySteward {
        require(_node != address(0), "Invalid node coordinates");
        require(!computeNodes[_node].isRegistered, "Node profile already enrolled inside registry");

        computeNodes[_node] = NodeMetrics({
            totalJobsExecuted: 0,
            successfulProofs: 0,
            trustScore: 100, // Starts at perfect absolute trust score baseline
            isRegistered: true
        });
    }

    /// @notice Log a complex infrastructure mathematical calculation or execution job sequence
    function initializeComputeJob(bytes32 _jobId, address _node, bytes32 _inputHash) external onlySteward {
        require(_jobId != bytes32(0), "Invalid computation job identifier hash");
        require(computeNodes[_node].isRegistered, "Access Denied: Computation node not active in validation mesh");
        require(computeNodes[_node].trustScore >= MIN_TRUST_SCORE, "Security Block: Node trust rating below secure limit");

        computeJobsRegistry[_jobId] = ComputeJob({
            computationNode: _node,
            inputStateHash: _inputHash,
            validatedOutputHash: bytes32(0),
            statusFinalized: false,
            executionVerified: false,
            submittedAtBlock: block.number
        });

        computeNodes[_node].totalJobsExecuted += 1;
        emit ComputeJobLogged(_jobId, _node, _inputHash);
    }

    /// @notice Cryptographically verify structural computational outputs via execution proof matching
    /// @param _jobId Unique tracking code of the evaluated compute job instance
    /// @param _outputHash The computed state result packet fingerprint
    /// @param _proofHash Cryptographic verification hash (e.g., ZK execution proof or verifiable computation trace)
    /// @param _proofIsValid True if external mathematical validation layers confirm signature correctness
    function verifyComputationProof(
        bytes32 _jobId,
        bytes32 _outputHash,
        bytes32 _proofHash,
        bool _proofIsValid
    ) external onlySteward {
        ComputeJob storage job = computeJobsRegistry[_jobId];
        require(job.submittedAtBlock > 0, "Target job profile configuration does not exist");
        require(!job.statusFinalized, "Execution Collision: Computation job parameters already finalized");

        address node = job.computationNode;
        job.statusFinalized = true;

        if (strictProofValidationActive && !_proofIsValid) {
            job.executionVerified = false;
            
            // Degradation Loop: Penalize computing node trust ranking for faulty outputs
            if (computeNodes[node].trustScore > 15) {
                computeNodes[node].trustScore -= 15;
            } else {
                computeNodes[node].trustScore = 0;
            }

            emit ComputationalFaultFlagged(node, _jobId, "Mathematical Fault: Cryptographic execution proof failed verification");
        } else {
            job.executionVerified = true;
            job.validatedOutputHash = _outputHash;
            computeNodes[node].successfulProofs += 1;
            
            // Recalibrate node efficiency token score toward optimal performance index
            if (computeNodes[node].trustScore < 100) {
                computeNodes[node].trustScore += 1;
            }
        }

        emit ProofVerified(_jobId, _proofHash, job.executionVerified);
    }

    /// @notice Read-only inspection checking trust rating parameters of hardware nodes
    function checkNodeStature(address _node) external view returns (bool active, uint256 rating, uint256 reliabilityRate) {
        NodeMetrics memory metrics = computeNodes[_node];
        if (metrics.totalJobsExecuted == 0) {
            return (metrics.isRegistered, metrics.trustScore, 0);
        }
        uint256 rate = (metrics.successfulProofs * 100) / metrics.totalJobsExecuted;
        return (metrics.isRegistered, metrics.trustScore, rate);
    }

    /// @notice Toggle strict execution checks across runtime environments
    function toggleStrictVerification(bool _strictMode) external onlySteward {
        strictProofValidationActive = _strictMode;
    }

    /// @notice Upgrade or migrate the central Integrity Steward cryptographic signing block
    function transferIntegrityAuthority(address _newSteward) external onlySteward {
        require(_newSteward != address(0), "Invalid upgrade destination coordinates");
        emit IntegrityAuthorityTransferred(integritySteward, _newSteward);
        integritySteward = _newSteward;
    }
}
