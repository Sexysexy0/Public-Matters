// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlanetaryExperimentSanctifier {
    enum ExperimentType { Educational, Diplomatic, Resource, Environmental, Cultural }
    enum SanctificationStatus { Proposed, Active, Completed, Archived }

    struct Experiment {
        uint256 id;
        string title;
        ExperimentType experimentType;
        string sanctumRegion;
        string steward;
        uint256 startDate;
        uint256 endDate;
        SanctificationStatus status;
        string ritualTag;
    }

    mapping(uint256 => Experiment) public experimentRegistry;
    uint256 public experimentCount;

    event ExperimentSanctified(uint256 id, string title, string sanctumRegion);
    event ExperimentCompleted(uint256 id);
    event ExperimentArchived(uint256 id);

    function sanctifyExperiment(
        string memory title,
        ExperimentType experimentType,
        string memory sanctumRegion,
        string memory steward,
        uint256 startDate,
        uint256 endDate,
        string memory ritualTag
    ) public {
        experimentRegistry[experimentCount] = Experiment(
            experimentCount,
            title,
            experimentType,
            sanctumRegion,
            steward,
            startDate,
            endDate,
            SanctificationStatus.Active,
            ritualTag
        );
        emit ExperimentSanctified(experimentCount, title, sanctumRegion);
        experimentCount++;
    }

    function completeExperiment(uint256 id) public {
        require(id < experimentCount, "Invalid experiment ID");
        experimentRegistry[id].status = SanctificationStatus.Completed;
        emit ExperimentCompleted(id);
    }

    function archiveExperiment(uint256 id) public {
        require(id < experimentCount, "Invalid experiment ID");
        experimentRegistry[id].status = SanctificationStatus.Archived;
        emit ExperimentArchived(id);
    }

    function getExperiment(uint256 id) public view returns (Experiment memory) {
        return experimentRegistry[id];
    }
}
