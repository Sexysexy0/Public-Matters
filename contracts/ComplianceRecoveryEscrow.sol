// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ComplianceRecoveryEscrow {
    address public guardian;
    address public publicBenefitVault; // Address kung saan mapupunta ang pondo kapag bagsak sila

    enum EscrowStatus { Active, Resolved, Forfeited }

    struct RecoveryCase {
        address institution;
        uint256 collateralAmount;
        string requiredImprovement; // Ang nakatalagang misyon o solusyon na dapat nilang gawin
        uint256 deadline;
        EscrowStatus status;
    }

    uint256 public totalCases;
    mapping(uint256 => RecoveryCase) public cases;

    event RecoveryInitiated(uint256 indexed caseId, address indexed institution, uint256 amount, uint256 deadline);
    event RecoverySuccess(uint256 indexed caseId, address indexed institution);
    event RecoveryForfeited(uint256 indexed caseId, address indexed institution);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Access denied. Only the Guardian can manage recovery cases.");
        _;
    }

    constructor(address _publicBenefitVault) {
        guardian = msg.sender;
        publicBenefitVault = _publicBenefitVault;
    }

    // Isang institusyon ang magpapasok ng kanilang piyansa/collateral para sa pagbabago
    function initiateRecovery(
        string memory _requiredImprovement, 
        uint256 _durationInSeconds
    ) public payable returns (uint256) {
        require(msg.value > 0, "Collateral must be greater than zero.");
        
        totalCases++;
        cases[totalCases] = RecoveryCase({
            institution: msg.sender,
            collateralAmount: msg.value,
            requiredImprovement: _requiredImprovement,
            deadline: block.timestamp + _durationInSeconds,
            status: EscrowStatus.Active
        });

        emit RecoveryInitiated(totalCases, msg.sender, msg.value, block.timestamp + _durationInSeconds);
        return totalCases;
    }

    // Aprubahan ng Guardian kapag nagawa ng institusyon ang nakatalagang improvement (Atonement Complete)
    function approveRecovery(uint256 _caseId) public onlyGuardian {
        RecoveryCase storage c = cases[_caseId];
        require(c.status == EscrowStatus.Active, "Case is no longer active.");
        require(block.timestamp <= c.deadline, "Deadline has already passed.");

        c.status = EscrowStatus.Resolved;
        
        // Ibalik ang collateral sa institusyon bilang gantimpala sa pagbabago
        payable(c.institution).transfer(c.collateralAmount);
        emit RecoverySuccess(_caseId, c.institution);
    }

    // Rematado/Forfeited ang pondo kapag lumagpas sa deadline at walang ginawang pagbabago ang institusyon
    function forfeitCollateral(uint256 _caseId) public onlyGuardian {
        RecoveryCase storage c = cases[_caseId];
        require(c.status == EscrowStatus.Active, "Case is no longer active.");
        require(block.timestamp > c.deadline, "Institution still has time to comply.");

        c.status = EscrowStatus.Forfeited;
        
        // Ipadala ang pondo sa pampublikong benepisyo dahil sa hindi pagtupad sa pangako
        payable(publicBenefitVault).transfer(c.collateralAmount);
        emit RecoveryForfeited(_caseId, c.institution);
    }
}
