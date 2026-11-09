// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title ImpactBondEscrowV2
 * @notice Performance-based funding for NGOs. Pull-based payments, CEI pattern.
 */
contract ImpactBondEscrowV2 is ReentrancyGuard {
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
    mapping(address => uint256) public pendingWithdrawals;

    event ProjectCreated(bytes32 indexed projectId, address indexed donor, address indexed ngo);
    event FundsDeposited(bytes32 indexed projectId, uint256 amount);
    event ImpactVerified(bytes32 indexed projectId, bytes32 proofHash, uint256 releasedAmount);
    event Withdrawal(address indexed recipient, uint256 amount);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function createProject(bytes32 projectId, address ngo) external payable nonReentrant {
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

    function submitImpactProof(bytes32 projectId, bytes32 proofHash) external {
        Project storage p = projects[projectId];
        require(p.active, "Project inactive");
        require(msg.sender == p.ngo, "Only assigned NGO");
        p.latestProofHash = proofHash;
    }

    function verifyImpactAndRelease(bytes32 projectId, uint256 releaseAmount) external nonReentrant onlyOperator {
        Project storage p = projects[projectId];
        require(p.active, "Project inactive");
        require(p.latestProofHash != bytes32(0), "No proof submitted");
        require(p.releasedAmount + releaseAmount <= p.totalDeposited, "Exceeds funds");

        // Effects first (CEI)
        p.releasedAmount += releaseAmount;
        p.latestProofHash = bytes32(0);
        verifiedProofCount[projectId]++;
        pendingWithdrawals[p.ngo] += releaseAmount;

        if (p.releasedAmount == p.totalDeposited) {
            p.active = false;
        }

        emit ImpactVerified(projectId, p.latestProofHash, releaseAmount);

        // No external call — pull-based
    }

    function withdraw() external nonReentrant {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "No funds to withdraw");

        pendingWithdrawals[msg.sender] = 0; // CEI: state bago call
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawal(msg.sender, amount);
    }
}
