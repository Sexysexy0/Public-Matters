// CommunityTargetingDAO.sol
pragma solidity ^0.8.0;

contract CommunityTargetingDAO {
    struct Applicant {
        string name;
        uint256 validationPoints;
        bool blacklisted;
        bool approved;
    }

    mapping(address => Applicant) public registry;

    function vouchForMember(address _member) public {
        require(!registry[_member].blacklisted, "Member is flagged");
        registry[_member].validationPoints++;
        
        if (registry[_member].validationPoints >= 5) { // Threshold for inclusion
            registry[_member].approved = true;
        }
    }

    function reportIneligibility(address _member) public {
        registry[_member].blacklisted = true;
        registry[_member].approved = false;
    }
}
