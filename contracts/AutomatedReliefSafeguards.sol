// AutomatedReliefSafeguards.sol
pragma solidity ^0.8.0;

contract AutomatedReliefSafeguards {
    struct Household {
        uint256 baseSubsidy;
        uint256 lastDisbursement;
        bool isEligible;
    }

    mapping(address => Household) public beneficiaries;
    uint256 public inflationAdjustmentFactor; // e.g. 105 for 5% increase

    function adjustForInflation(uint256 _newFactor) public {
        inflationAdjustmentFactor = _newFactor;
    }

    function calculatePayable(address _account) public view returns (uint256) {
        Household memory hh = beneficiaries[_account];
        return (hh.baseSubsidy * inflationAdjustmentFactor) / 100;
    }
}
