// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";
import "./LocalMaintenanceTrainingRegistry.sol";

contract MilestoneMaintenanceEscrow {
    OperatorPrivileges public immutable privileges;

    struct Escrow {
        uint256 balance;
        uint256 lastMaintenanceProof;
        bool isBroken;
    }

    mapping(bytes32 => Escrow) public escrows; // projectId => Escrow
    uint256 public constant MAINTENANCE_INTERVAL = 90 days;

    event FundsDeposited(bytes32 indexed projectId, uint256 amount);
    event MaintenanceProven(bytes32 indexed projectId, uint256 amountReleased);
    event ProjectBroken(bytes32 indexed projectId, uint256 fundsReturnedToDonor);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    LocalMaintenanceTrainingRegistry public trainingRegistry;

    constructor(address _privileges, address _trainingRegistry) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
        trainingRegistry = LocalMaintenanceTrainingRegistry(_trainingRegistry);
    }

    function depositFunds(bytes32 projectId) external payable {
        require(msg.value > 0, "No funds");
        escrows[projectId].balance += msg.value;
        escrows[projectId].lastMaintenanceProof = block.timestamp;
        emit FundsDeposited(projectId, msg.value);
    }

    // Tinatawag ito ng local operator kapag na-maintain nila ang well.
    // Nagre-release ito ng pondo para sa susunod na 3 buwan.
    function proveMaintenance(bytes32 projectId, address payable localOperator, bytes32 assetTypeHash) external onlyOperator {
        Escrow storage e = escrows[projectId];
        require(e.balance > 0, "No funds left");
        require(!e.isBroken, "Project marked broken");
        
        // THE KNOWLEDGE TRANSFER CHECK:
        require(trainingRegistry.isCertified(localOperator, assetTypeHash), "Operator not certified to maintain this asset");
        
        uint256 releaseAmount = e.balance / 4; // Release 25% ng pondo bawat maintenance
        e.balance -= releaseAmount;
        e.lastMaintenanceProof = block.timestamp;

        (bool success, ) = localOperator.call{value: releaseAmount}("");
        require(success, "Transfer failed");

        emit MaintenanceProven(projectId, releaseAmount);
    }

    // Kung masira ang well at hindi ma-maintain, pwede itong i-flag ng operator.
    function flagAsBroken(bytes32 projectId, address payable donorRefund) external onlyOperator {
        Escrow storage e = escrows[projectId];
        require(!e.isBroken, "Already broken");
        
        e.isBroken = true;
        uint256 remaining = e.balance;
        e.balance = 0;

        if (remaining > 0) {
            (bool success, ) = donorRefund.call{value: remaining}("");
            require(success, "Refund failed");
        }

        emit ProjectBroken(projectId, remaining);
    }
}
