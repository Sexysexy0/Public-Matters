// SPDX-License-Identifier: Youth-Onboarding
pragma solidity ^7.7.7;

contract GlobalJobCreationScroll {
    address public steward;
    uint public totalJobsCreated;

    struct JobEvent {
        string region;
        string sector;
        uint youthOnboarded;
        uint timestamp;
        bool greenOrDigital;
    }

    JobEvent[] public jobLog;

    event JobCreated(string region, string sector, uint youthOnboarded, uint timestamp, bool greenOrDigital);

    constructor() {
        steward = msg.sender;
        totalJobsCreated = 0;
    }

    function logJob(
        string memory region,
        string memory sector,
        uint youthOnboarded,
        bool greenOrDigital
    ) public {
        require(msg.sender == steward, "Only steward may log");
        jobLog.push(JobEvent(region, sector, youthOnboarded, block.timestamp, greenOrDigital));
        totalJobsCreated += 1;
        emit JobCreated(region, sector, youthOnboarded, block.timestamp, greenOrDigital);
    }

    function getLatestJob() public view returns (JobEvent memory) {
        require(jobLog.length > 0, "No jobs logged yet");
        return jobLog[jobLog.length - 1];
    }
}
