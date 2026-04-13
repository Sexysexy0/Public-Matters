// AntiDynastyAccountability.sol
pragma solidity ^0.8.0;

contract AntiDynastyAccountability {
    struct Candidate {
        string familyRoot;
        uint256 activeFamilyMembers;
        uint256 limit; 
    }

    mapping(address => Candidate) public registry;

    function validateCandidacy(address _candidate) public view returns (bool) {
        Candidate memory c = registry[_candidate];
        // Anti-dynasty logic: cannot run if more than 2 relatives are in power
        if (c.activeFamilyMembers >= c.limit) {
            return false;
        }
        return true;
    }
}
