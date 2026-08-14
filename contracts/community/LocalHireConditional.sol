// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LocalHireConditional {
    struct LaborAgreement {
        uint256 totalHires;
        uint256 localHires;
        uint256 requiredLocalPercentage; // e.g., 2000 = 20%
        bool isCompliant;
        uint256 escrowAmount;
    }

    mapping(address => LaborAgreement) public agreements;
    mapping(address => uint256) public escrowBalances;

    event LaborAgreementCreated(address indexed operator, uint256 requiredPercentage);
    event LocalHireReported(address indexed operator, uint256 local, uint256 total);
    event EscrowDeposited(address indexed operator, uint256 amount);
    event ComplianceUpdated(address indexed operator, bool isCompliant);

    constructor() {}

    function createAgreement(uint256 _requiredLocalPercentage) external payable {
        require(agreements[msg.sender].totalHires == 0, "Agreement exists");
        agreements[msg.sender] = LaborAgreement({
            totalHires: 0,
            localHires: 0,
            requiredLocalPercentage: _requiredLocalPercentage,
            isCompliant: false,
            escrowAmount: msg.value
        });
        escrowBalances[msg.sender] = msg.value;
        emit LaborAgreementCreated(msg.sender, _requiredLocalPercentage);
        emit EscrowDeposited(msg.sender, msg.value);
    }

    function reportHires(uint256 _localHires, uint256 _totalHires) external {
        LaborAgreement storage agreement = agreements[msg.sender];
        agreement.localHires += _localHires;
        agreement.totalHires += _totalHires;

        uint256 currentPercentage = (agreement.localHires * 10000) / agreement.totalHires;
        if (currentPercentage >= agreement.requiredLocalPercentage) {
            agreement.isCompliant = true;
            // Release escrow if compliant
        } else {
            agreement.isCompliant = false;
        }
        emit LocalHireReported(msg.sender, agreement.localHires, agreement.totalHires);
        emit ComplianceUpdated(msg.sender, agreement.isCompliant);
    }

    function getComplianceStatus(address _operator) external view returns (bool) {
        return agreements[_operator].isCompliant;
    }
}
