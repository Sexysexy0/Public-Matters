// HousingQualificationAccountability.sol
pragma solidity ^0.8.0;

contract HousingQualificationAccountability {
    struct Applicant {
        bytes32 identityHash;
        uint256 incomeLevel;
        bool ownsExistingProperty;
        bool isApproved;
    }

    mapping(address => Applicant) public applicants;

    function evaluateApplication(address _user, uint256 _income, bool _ownsProperty) public {
        // Strict Logic: Must be below income threshold and own NO other property
        bool eligible = (_income < 20000) && (!_ownsProperty);
        
        applicants[_user] = Applicant(keccak256(abi.encodePacked(_user)), _income, _ownsProperty, eligible);
    }

    function auditSelection(address _user) public view returns (string memory) {
        if (applicants[_user].isApproved) {
            return "QUALIFIED: Meets all equity standards.";
        }
        return "DENIED: Failed eligibility or potential property ownership detected.";
    }
}
