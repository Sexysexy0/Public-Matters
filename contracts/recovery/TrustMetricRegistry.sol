// SPDX-License-Identifier: Trust-License
pragma solidity ^0.8.19;

contract TrustMetricRegistry {
    struct TrustScore {
        address steward;
        string sanctumTag;
        uint8 empathy;
        uint8 transparency;
        uint8 resonance;
        string auditNote;
    }

    TrustScore[] public scores;
    address public registrar;

    event TrustScoreLogged(address steward, string sanctumTag, uint8 empathy, uint8 transparency, uint8 resonance, string auditNote);

    constructor() {
        registrar = msg.sender;
    }

    function logTrustScore(string memory sanctumTag, uint8 empathy, uint8 transparency, uint8 resonance, string memory auditNote) public {
        scores.push(TrustScore(msg.sender, sanctumTag, empathy, transparency, resonance, auditNote));
        emit TrustScoreLogged(msg.sender, sanctumTag, empathy, transparency, resonance, auditNote);
    }

    function getScore(uint256 index) public view returns (TrustScore memory) {
        return scores[index];
    }

    function totalScores() public view returns (uint256) {
        return scores.length;
    }
}
