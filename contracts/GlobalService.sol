// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GlobalService
/// @notice Covenant to encode cross-border mission of service,
///         ensuring fairness, dignity, and uplift across nations.
contract GlobalService {
    address public overseer;
    uint256 public missionCount;

    struct Mission {
        uint256 id;
        string region;       // Philippines, Europe, US, Global
        string initiative;   // Housing, Education, Infrastructure, SocialSupport
        uint256 timestamp;
    }

    mapping(uint256 => Mission) public missions;

    event MissionDeclared(uint256 indexed id, string region, string initiative);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareMission(string calldata region, string calldata initiative) external onlyOverseer {
        missionCount++;
        missions[missionCount] = Mission(missionCount, region, initiative, block.timestamp);
        emit MissionDeclared(missionCount, region, initiative);
    }

    function viewMission(uint256 id) external view returns (Mission memory) {
        return missions[id];
    }
}
