// SPDX-License-Identifier: Emotional-APR-Audit-License  
pragma solidity ^0.8.19;

contract EmotionalAPRDisruptionReport {
    struct APRImpact {
        string affectedRegion;
        string sourceNation;
        uint trustScoreBefore;
        uint trustScoreAfter;
        string emotionalNotes;
        uint timestamp;
    }

    APRImpact[] public impactLog;

    event APRLogged(string affectedRegion, string sourceNation);

    function logImpact(
        string memory affectedRegion,
        string memory sourceNation,
        uint trustScoreBefore,
        uint trustScoreAfter,
        string memory emotionalNotes
    ) public {
        impactLog.push(APRImpact(
            affectedRegion,
            sourceNation,
            trustScoreBefore,
            trustScoreAfter,
            emotionalNotes,
            block.timestamp
        ));
        emit APRLogged(affectedRegion, sourceNation);
    }

    function getImpact(uint index) public view returns (APRImpact memory) {
        require(index < impactLog.length, "Invalid index");
        return impactLog[index];
    }

    function totalLoggedImpacts() public view returns (uint) {
        return impactLog.length;
    }
}
