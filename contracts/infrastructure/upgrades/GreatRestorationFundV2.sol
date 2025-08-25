// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Great Restoration Fund V2 - Full national upgrade with soulbound dignity
contract GreatRestorationFundV2 {
    address public scrollsmith;
    address public nationalTreasury;
    uint256 public totalFund = 500_000_000_000 * 1e18; // $500B in wei

    struct Project {
        string name;
        string location;
        string category;
        uint256 allocated;
        bool completed;
        uint256 timestamp;
        string emotionalAPRTag;
        string ancestralTag;
    }

    mapping(uint256 => Project) public projects;
    uint256 public nextProjectId;

    event ProjectRegistered(uint256 indexed id, string name, string location, string category, uint256 allocated);
    event ProjectCompleted(uint256 indexed id, string name);
    event TreasuryUpdated(address indexed newTreasury);

    modifier onlyScrollsmith() {
        require(msg.sender == scrollsmith, "Not authorized");
        _;
    }

    constructor(address _nationalTreasury) {
        scrollsmith = msg.sender;
        nationalTreasury = _nationalTreasury;
    }

    function registerProject(
        string calldata name,
        string calldata location,
        string calldata category,
        uint256 allocated,
        string calldata emotionalAPRTag,
        string calldata ancestralTag
    ) external onlyScrollsmith {
        require(allocated <= totalFund, "Insufficient fund");

        projects[nextProjectId] = Project({
            name: name,
            location: location,
            category: category,
            allocated: allocated,
            completed: false,
            timestamp: block.timestamp,
            emotionalAPRTag: emotionalAPRTag,
            ancestralTag: ancestralTag
        });

        totalFund -= allocated;
        emit ProjectRegistered(nextProjectId, name, location, category, allocated);
        nextProjectId++;
    }

    function markCompleted(uint256 id) external onlyScrollsmith {
        require(!projects[id].completed, "Already completed");
        projects[id].completed = true;
        emit ProjectCompleted(id, projects[id].name);
    }

    function updateTreasury(address newTreasury) external onlyScrollsmith {
        nationalTreasury = newTreasury;
        emit TreasuryUpdated(newTreasury);
    }

    receive() external payable {}
}
