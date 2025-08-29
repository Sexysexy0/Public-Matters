// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract ContractBiddingBroadcast {
    address public steward;

    struct Bid {
        string contractorName;
        uint256 bidAmount;
        string emotionalTag;
        bool broadcasted;
    }

    struct Project {
        string projectName;
        uint256 budgetCap;
        string location;
        bool biddingOpen;
        Bid[] bids;
    }

    Project[] public projects;

    event ProjectCreated(uint256 indexed id, string projectName, string location);
    event BidSubmitted(uint256 indexed projectId, string contractorName, uint256 bidAmount);
    event BidBroadcasted(uint256 indexed projectId, string contractorName, string emotionalTag);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward may cast scrolls");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function createProject(string memory name, uint256 budgetCap, string memory location) public onlySteward {
        Project storage newProject = projects.push();
        newProject.projectName = name;
        newProject.budgetCap = budgetCap;
        newProject.location = location;
        newProject.biddingOpen = true;
        emit ProjectCreated(projects.length - 1, name, location);
    }

    function submitBid(uint256 projectId, string memory contractorName, uint256 bidAmount) public {
        require(projects[projectId].biddingOpen, "Bidding closed");
        projects[projectId].bids.push(Bid(contractorName, bidAmount, "", false));
        emit BidSubmitted(projectId, contractorName, bidAmount);
    }

    function broadcastBid(uint256 projectId, uint256 bidIndex, string memory emotionalTag) public onlySteward {
        Bid storage bid = projects[projectId].bids[bidIndex];
        bid.emotionalTag = emotionalTag;
        bid.broadcasted = true;
        emit BidBroadcasted(projectId, bid.contractorName, emotionalTag);
    }

    function closeBidding(uint256 projectId) public onlySteward {
        projects[projectId].biddingOpen = false;
    }

    function getProject(uint256 id) public view returns (Project memory) {
        return projects[id];
    }

    function totalProjects() public view returns (uint256) {
        return projects.length;
    }
}
