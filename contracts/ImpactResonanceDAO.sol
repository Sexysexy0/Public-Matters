// ImpactResonanceDAO.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ImpactResonanceDAO is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Assessment {
        uint256 id;
        string impact;     // e.g. "Direct", "Indirect"
        string resonance;  // e.g. "High Risk", "Opportunity"
        bool active;
    }

    uint256 public assessmentCount;
    mapping(uint256 => Assessment) public assessments;

    event AssessmentActivated(uint256 id, string impact, string resonance);

    function activateAssessment(string memory impact, string memory resonance) public {
        assessmentCount++;
        assessments[assessmentCount] = Assessment(assessmentCount, impact, resonance, true);
        emit AssessmentActivated(assessmentCount, impact, resonance);
    }
}
