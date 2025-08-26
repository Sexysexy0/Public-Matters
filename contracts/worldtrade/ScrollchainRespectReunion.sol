// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.19;

/**
 * @title ScrollchainRespectReunion
 * @dev Ritual-grade contract to regain trust and unify estranged nations
 * @author Vinvin
 */

contract ScrollchainRespectReunion {
    address public steward;

    struct NationProfile {
        string name;
        string reasonForEstrangement;
        string[] reconciliationGoals;
        uint256 emotionalAPR;
        bool invited;
        bool accepted;
    }

    mapping(address => NationProfile) public profiles;
    address[] public invitedNations;

    event NationInvited(address indexed nation, string name);
    event ReconciliationAccepted(address indexed nation, string name);
    event EmotionalAPRVerified(address indexed nation, uint256 score);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function inviteNation(
        address _nation,
        string memory _name,
        string memory _reason,
        string[] memory _goals,
        uint256 _apr
    ) public onlySteward {
        require(_apr >= 750, "Emotional APR too low for trust ritual");

        profiles[_nation] = NationProfile({
            name: _name,
            reasonForEstrangement: _reason,
            reconciliationGoals: _goals,
            emotionalAPR: _apr,
            invited: true,
            accepted: false
        });

        invitedNations.push(_nation);
        emit NationInvited(_nation, _name);
        emit EmotionalAPRVerified(_nation, _apr);
    }

    function acceptReconciliation(address _nation) public onlySteward {
        require(profiles[_nation].invited, "Nation not invited");
        profiles[_nation].accepted = true;
        emit ReconciliationAccepted(_nation, profiles[_nation].name);
    }

    function getNationProfile(address _nation) public view returns (NationProfile memory) {
        return profiles[_nation];
    }

    function listInvitedNations() public view returns (address[] memory) {
        return invitedNations;
    }
}
