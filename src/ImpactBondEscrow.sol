// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

/**
 * @title ImpactBondEscrow
 * @notice Performance-based funding for NGOs. Funds are released only when verifiable impact is proven.
 */
contract ImpactBondEscrow {
    OperatorPrivileges public immutable privileges;

    struct Project {
        address donor;
        address ngo;
        uint256 totalDeposited;
        uint256 releasedAmount;
        bytes32 latestProofHash;
        bool active;
    }

    mapping(bytes32 => Project) public projects;
    mapping(bytes32 => uint256) public verifiedProofCount;

    event ProjectCreated(bytes32 indexed projectId, address indexed donor, address indexed ngo);
    event FundsDeposited(bytes32 indexed projectId, uint256 amount);
    event ImpactVerified(bytes32 indexed projectId, bytes32 proofHash, uint256 releasedAmount);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function createProject(bytes32 projectId, address ngo) external payable {
        require(projects[projectId].donor == address(0), "Project exists");
        require(msg.value > 0, "No funds");

        projects[projectId] = Project({
            donor: msg.sender,
            ngo: ngo,
            totalDeposited: msg.value,
            releasedAmount: 0,
            latestProofHash: bytes32(0),
            active: true
        });

        emit ProjectCreated(projectId, msg.sender, ngo);
        emit FundsDeposited(projectId, msg.value);
    }

    /**
     * @notice NGO submits proof of impact (e.g., IPFS hash of river cleanup).
     */
    function submitImpactProof(bytes32 projectId, bytes32 proofHash) external {
        Project storage p = projects[projectId];
        require(p.active, "Project inactive");
        require(msg.sender == p.ngo, "Only assigned NGO");
        p.latestProofHash = proofHash;
    }

    /**
     * @notice Independent operator verifies the proof and releases a tranche of funds.
     */
    function verifyImpactAndRelease(bytes32 projectId, uint256 releaseAmount) external onlyOperator {
        Project storage p = projects[projectId];
        require(p.active, "Project inactive");
        require(p.latestProofHash != bytes32(0), "No proof submitted");
        require(p.releasedAmount + releaseAmount <= p.totalDeposited, "Exceeds funds");

        p.releasedAmount += releaseAmount;
        p.latestProofHash = bytes32(0); // Reset for next milestone
        verifiedProofCount[projectId]++;

        (bool success, ) = payable(p.ngo).call{value: releaseAmount}("");
        require(success, "Transfer failed");

        emit ImpactVerified(projectId, p.latestProofHash, releaseAmount);
        
        if (p.releasedAmount == p.totalDeposited) {
            p.active = false;
        }
    }
}
