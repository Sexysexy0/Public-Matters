// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract EmotionalAPROracle {
    struct APRScore {
        string response;
        uint256 empathy;
        uint256 clarity;
        uint256 civicResonance;
        uint256 totalAPR;
    }

    APRScore[] public scores;

    event APRCalculated(uint256 indexed scoreId, uint256 totalAPR);

    function scoreResponse(
        string memory _response,
        uint256 _empathy,
        uint256 _clarity,
        uint256 _civicResonance
    ) public {
        uint256 total = (_empathy + _clarity + _civicResonance) / 3;
        scores.push(APRScore(_response, _empathy, _clarity, _civicResonance, total));
        emit APRCalculated(scores.length - 1, total);
    }

    function getScore(uint256 _index) public view returns (APRScore memory) {
        return scores[_index];
    }

    function totalScores() public view returns (uint256) {
        return scores.length;
    }
}
