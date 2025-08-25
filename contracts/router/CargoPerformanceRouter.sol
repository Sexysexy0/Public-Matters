// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CargoPerformanceRouter {
    struct Vessel {
        string id;
        uint256 rerouteSpeed; // in hours
        string feedback;
        uint8 emotionalAPR; // 0–100 scale
        uint256 baseFee;
        bool damayClauseHonored;
    }

    mapping(string => Vessel) public vessels;
    event VesselScored(string id, uint256 score, string feedback);

    function scoreVessel(
        string memory _id,
        uint256 _rerouteSpeed,
        string memory _feedback,
        uint8 _emotionalAPR,
        uint256 _baseFee,
        bool _damayClauseHonored
    ) public {
        require(_emotionalAPR <= 100, "Invalid APR");
        uint256 score = calculateScore(_rerouteSpeed, _emotionalAPR, _damayClauseHonored);
        vessels[_id] = Vessel(_id, _rerouteSpeed, _feedback, _emotionalAPR, _baseFee, _damayClauseHonored);
        emit VesselScored(_id, score, _feedback);
    }

    function calculateScore(
        uint256 speed,
        uint8 apr,
        bool damay
    ) internal pure returns (uint256) {
        uint256 base = 1000;
        uint256 speedFactor = speed < 72 ? 200 : (speed < 120 ? 100 : 50);
        uint256 aprFactor = apr * 5;
        uint256 damayBonus = damay ? 150 : 0;
        return base + speedFactor + aprFactor + damayBonus;
    }

    function getVesselScore(string memory _id) public view returns (uint256) {
        Vessel memory v = vessels[_id];
        return calculateScore(v.rerouteSpeed, v.emotionalAPR, v.damayClauseHonored);
    }
}
