// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PlanetaryCurriculum {
    struct CurriculumEpisode {
        uint256 scrollId;
        string theme; // e.g. "Grief & Solidarity", "Damay Protocols", "Ancestral Memory"
        string lesson;
        string region;
        uint256 timestamp;
    }

    CurriculumEpisode[] public episodes;
    address public steward;

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized curriculum caster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function archiveEpisode(
        uint256 _scrollId,
        string memory _theme,
        string memory _lesson,
        string memory _region
    ) external onlySteward {
        episodes.push(CurriculumEpisode(_scrollId, _theme, _lesson, _region, block.timestamp));
    }

    function getEpisode(uint256 _id) external view returns (CurriculumEpisode memory) {
        return episodes[_id];
    }

    function totalEpisodes() external view returns (uint256) {
        return episodes.length;
    }
}
