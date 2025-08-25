// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VerticalHousingSanctum {
    address public scrollsmith;
    uint256 public totalHousingFund = 100_000_000_000 * 1e18; // $100B allocation

    struct HousingProject {
        string city;
        string barangay;
        uint256 units;
        uint256 allocated;
        bool completed;
        string damayClause;
        string contractorTag;
        string ancestralDesignTag;
        uint256 timestamp;
    }

    mapping(uint256 => HousingProject) public projects;
    uint256 public nextProjectId;

    event HousingProjectRegistered(string city, string barangay, uint256 units);
    event HousingProjectCompleted(string barangay);

    modifier onlyScrollsmith() {
        require(msg.sender == scrollsmith, "Unauthorized");
        _;
    }

    constructor() {
        scrollsmith = msg.sender;
    }

    function registerHousingProject(
        string calldata city,
        string calldata barangay,
        uint256 units,
        uint256 allocated,
        string calldata damayClause,
        string calldata contractorTag,
        string calldata ancestralDesignTag
    ) external onlyScrollsmith {
        require(allocated <= totalHousingFund, "Insufficient fund");

        projects[nextProjectId] = HousingProject({
            city: city,
            barangay: barangay,
            units: units,
            allocated: allocated,
            completed: false,
            damayClause: damayClause,
            contractorTag: contractorTag,
            ancestralDesignTag: ancestralDesignTag,
            timestamp: block.timestamp
        });

        totalHousingFund -= allocated;
        emit HousingProjectRegistered(city, barangay, units);
        nextProjectId++;
    }

    function markCompleted(uint256 id) external onlyScrollsmith {
        projects[id].completed = true;
        emit HousingProjectCompleted(projects[id].barangay);
    }
}
