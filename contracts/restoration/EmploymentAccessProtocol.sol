// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title EmploymentAccessProtocol
/// @dev Ritualizes job access, emotional APR, and damay clause for inclusive hiring

contract EmploymentAccessProtocol {
    address public steward;
    uint256 public jobCounter;

    struct JobScroll {
        uint256 id;
        string title;
        string sector;
        string location;
        bool isActive;
        string emotionalAPR;
        string damayClause;
    }

    mapping(uint256 => JobScroll) public jobScrolls;

    event JobScrollDeployed(uint256 indexed id, string title, string sector, string location);
    event JobScrollUpdated(uint256 indexed id, bool isActive, string emotionalAPR);

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: not a scroll-certified steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        jobCounter = 0;
    }

    function deployJobScroll(
        string memory _title,
        string memory _sector,
        string memory _location,
        string memory _emotionalAPR,
        string memory _damayClause
    ) public onlySteward {
        jobCounter++;
        jobScrolls[jobCounter] = JobScroll(
            jobCounter,
            _title,
            _sector,
            _location,
            true,
            _emotionalAPR,
            _damayClause
        );
        emit JobScrollDeployed(jobCounter, _title, _sector, _location);
    }

    function updateJobScroll(
        uint256 _id,
        bool _isActive,
        string memory _emotionalAPR
    ) public onlySteward {
        require(_id <= jobCounter, "Scroll not found");
        jobScrolls[_id].isActive = _isActive;
        jobScrolls[_id].emotionalAPR = _emotionalAPR;
        emit JobScrollUpdated(_id, _isActive, _emotionalAPR);
    }

    function getJobScroll(uint256 _id) public view returns (JobScroll memory) {
        return jobScrolls[_id];
    }
}
