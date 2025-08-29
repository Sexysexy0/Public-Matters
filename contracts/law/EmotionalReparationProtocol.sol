// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract EmotionalReparationProtocol {
    address public steward;

    struct ReparationEntry {
        string community;
        string breachType; // e.g., "Ghost Project", "Fund Looting", "Emotional Betrayal"
        uint256 emotionalDamageScore; // Scale: 0–1000
        uint256 fundReparationAmount;
        string healingUse; // e.g., "Sanctum Clinic", "Kinder Scholarship", "Emotional APR Workshop"
        bool witnessSigned;
        uint256 timestamp;
    }

    ReparationEntry[] public reparations;

    event ReparationLogged(
        string community,
        string breachType,
        uint256 damageScore,
        uint256 reparationAmount,
        string healingUse,
        uint256 timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logReparation(
        string memory community,
        string memory breachType,
        uint256 emotionalDamageScore,
        uint256 fundReparationAmount,
        string memory healingUse,
        bool witnessSigned
    ) public onlySteward {
        ReparationEntry memory newEntry = ReparationEntry({
            community: community,
            breachType: breachType,
            emotionalDamageScore: emotionalDamageScore,
            fundReparationAmount: fundReparationAmount,
            healingUse: healingUse,
            witnessSigned: witnessSigned,
            timestamp: block.timestamp
        });

        reparations.push(newEntry);
        emit ReparationLogged(
            community,
            breachType,
            emotionalDamageScore,
            fundReparationAmount,
            healingUse,
            block.timestamp
        );
    }

    function getReparation(uint256 index) public view returns (ReparationEntry memory) {
        require(index < reparations.length, "Invalid index");
        return reparations[index];
    }

    function totalReparations() public view returns (uint256) {
        return reparations.length;
    }
}
