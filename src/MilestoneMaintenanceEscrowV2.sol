// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";
import "./LocalMaintenanceTrainingRegistry.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title MilestoneMaintenanceEscrowV2
 * @notice Pull-based escrow. Donor at operator ay naka-record sa deposit,
 *         withdrawal via pull pattern. CEI + nonReentrant.
 */
contract MilestoneMaintenanceEscrowV2 is ReentrancyGuard {
    OperatorPrivileges public immutable privileges;
    LocalMaintenanceTrainingRegistry public immutable trainingRegistry;

    struct Escrow {
        uint256 balance;
        uint256 lastMaintenanceProof;
        bool isBroken;
        address donor;
        address localOperator;
    }

    mapping(bytes32 => Escrow) public escrows;
    mapping(address => uint256) public pendingWithdrawals;
    uint256 public constant MAINTENANCE_INTERVAL = 90 days;

    event FundsDeposited(bytes32 indexed projectId, address indexed donor, uint256 amount);
    event MaintenanceProven(bytes32 indexed projectId, uint256 amountReleased);
    event ProjectBroken(bytes32 indexed projectId, uint256 fundsReturnedToDonor);
    event Withdrawal(address indexed recipient, uint256 amount);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges, address _trainingRegistry) {
        require(_privileges != address(0), "privileges=0");
        require(_trainingRegistry != address(0), "training=0");
        privileges = OperatorPrivileges(_privileges);
        trainingRegistry = LocalMaintenanceTrainingRegistry(_trainingRegistry);
    }

    function depositFunds(bytes32 projectId, address localOperator) external payable nonReentrant {
        require(msg.value > 0, "No funds");
        require(escrows[projectId].donor == address(0), "Project exists");

        escrows[projectId] = Escrow({
            balance: msg.value,
            lastMaintenanceProof: block.timestamp,
            isBroken: false,
            donor: msg.sender,
            localOperator: localOperator
        });

        emit FundsDeposited(projectId, msg.sender, msg.value);
    }

    function proveMaintenance(bytes32 projectId, bytes32 assetTypeHash) external nonReentrant onlyOperator {
        Escrow storage e = escrows[projectId];
        require(e.balance > 0, "No funds left");
        require(!e.isBroken, "Project marked broken");
        require(trainingRegistry.isCertified(e.localOperator, assetTypeHash), "Operator not certified");

        // CEI: state bago external call
        uint256 releaseAmount = e.balance / 4;
        e.balance -= releaseAmount;
        e.lastMaintenanceProof = block.timestamp;
        pendingWithdrawals[e.localOperator] += releaseAmount;

        emit MaintenanceProven(projectId, releaseAmount);
    }

    function flagAsBroken(bytes32 projectId) external nonReentrant onlyOperator {
        Escrow storage e = escrows[projectId];
        require(!e.isBroken, "Already broken");

        // CEI: state bago external call
        e.isBroken = true;
        uint256 remaining = e.balance;
        e.balance = 0;
        pendingWithdrawals[e.donor] += remaining;

        emit ProjectBroken(projectId, remaining);
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
