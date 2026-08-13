// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransparencyMandateRegistry {
    struct Mandate {
        string projectName;
        uint256 filingBlock;
        uint256 mandatoryWaitPeriod; // seconds
        bool disclosed;
        bool approved;
    }

    mapping(bytes32 => Mandate) public mandates;
    address public steward;

    event ProjectFiled(bytes32 indexed projectId, string projectName, uint256 waitPeriod);
    event ProjectApproved(bytes32 indexed projectId);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function fileProject(bytes32 projectId, string memory projectName, uint256 waitPeriodMonths) external onlySteward {
        mandates[projectId] = Mandate({
            projectName: projectName,
            filingBlock: block.number,
            mandatoryWaitPeriod: waitPeriodMonths * 30 days,
            disclosed: true,
            approved: false
        });
        emit ProjectFiled(projectId, projectName, mandates[projectId].mandatoryWaitPeriod);
    }

    function approveProject(bytes32 projectId) external onlySteward {
        Mandate storage m = mandates[projectId];
        require(m.disclosed, "Not filed");
        uint256 secondsPerBlock = 12;
        require((block.number - m.filingBlock) * secondsPerBlock >= m.mandatoryWaitPeriod, "Wait period active");
        m.approved = true;
        emit ProjectApproved(projectId);
    }
}
