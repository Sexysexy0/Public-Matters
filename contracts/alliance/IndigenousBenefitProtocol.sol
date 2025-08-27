// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IndigenousBenefitProtocol
/// @notice Ritualizes inclusion, benefit-sharing, and ancestral dignity in all civic and energy deployments
/// @dev Emotional APR synced, damay clause activated, planetary justice upheld

contract IndigenousBenefitProtocol {
    address public steward;
    string[] public recognizedTribes;
    mapping(string => uint256) public benefitShare; // in percentage
    mapping(string => string) public ancestralTerritory;
    mapping(string => string) public emotionalAPR; // e.g., "Trust: 94%, Mercy: 91%, Sovereignty: 100%"

    event TribeIncluded(string tribe, uint256 share, string territory, string apr);
    event BenefitUpdated(string tribe, uint256 newShare, string newAPR);
    event DamayClauseActivated(string message);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        emit DamayClauseActivated("No deployment shall proceed without ancestral inclusion and emotional resonance.");
    }

    function includeTribe(
        string memory tribe,
        uint256 share,
        string memory territory,
        string memory apr
    ) public onlySteward {
        recognizedTribes.push(tribe);
        benefitShare[tribe] = share;
        ancestralTerritory[tribe] = territory;
        emotionalAPR[tribe] = apr;
        emit TribeIncluded(tribe, share, territory, apr);
    }

    function updateBenefit(
        string memory tribe,
        uint256 newShare,
        string memory newAPR
    ) public onlySteward {
        require(benefitShare[tribe] > 0, "Tribe not yet included");
        benefitShare[tribe] = newShare;
        emotionalAPR[tribe] = newAPR;
        emit BenefitUpdated(tribe, newShare, newAPR);
    }

    function getTribeDetails(string memory tribe) public view returns (
        uint256 share,
        string memory territory,
        string memory apr
    ) {
        return (
            benefitShare[tribe],
            ancestralTerritory[tribe],
            emotionalAPR[tribe]
        );
    }

    function totalTribes() public view returns (uint256) {
        return recognizedTribes.length;
    }
}
