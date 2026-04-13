// AIGovernanceDAO.sol
pragma solidity ^0.8.0;

contract AIGovernanceDAO {
    struct AIPolicy {
        string feature; // e.g., "Facial Recognition"
        bool isEnabled;
        uint256 communityVotes;
    }

    mapping(string => AIPolicy) public policyRegistry;

    function voteOnFeature(string memory _feature, bool _support) public {
        if (_support) {
            policyRegistry[_feature].communityVotes++;
        }
        
        // Threshold check: 60% of DAO members must agree
        if (policyRegistry[_feature].communityVotes > 1000) {
            policyRegistry[_feature].isEnabled = true;
        }
    }
}
