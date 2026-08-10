// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

interface ITrustIntegrator {
    function logPositiveAction(address entity, uint256 actionType) external;
}

/**
 * @title CommunityFloodVault
 * @notice Direct private-funded vault for community flood mitigation, drainage clearing, and infrastructure.
 */
contract CommunityFloodVault {
    address public immutable owner;
    ITrustIntegrator public immutable trustIntegrator;

    enum InitiativeStatus { Proposed, Funded, InProgress, Completed }

    struct FloodInitiative {
        string location;
        string description;
        address contractorOrLeader;
        uint256 requiredBudget;
        uint256 fundedAmount;
        InitiativeStatus status;
    }

    mapping(uint256 => FloodInitiative) public initiatives;
    uint256 public initiativeCount;

    event InitiativeCreated(uint256 indexed initiativeId, string location, address indexed leader, uint256 requiredBudget);
    event DirectFunded(uint256 indexed initiativeId, address indexed funder, uint256 amount);
    event InitiativeCompleted(uint256 indexed initiativeId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner permitted");
        _;
    }

    constructor(address _trustIntegrator) {
        require(_trustIntegrator != address(0), "Invalid integrator address");
        owner = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function createInitiative(
        string calldata location,
        string calldata description,
        address leader,
        uint256 requiredBudget
    ) external onlyOwner returns (uint256 initiativeId) {
        require(leader != address(0), "Invalid leader address");
        require(requiredBudget > 0, "Budget must be greater than zero");

        initiativeId = ++initiativeCount;
        initiatives[initiativeId] = FloodInitiative({
            location: location,
            description: description,
            contractorOrLeader: leader,
            requiredBudget: requiredBudget,
            fundedAmount: 0,
            status: InitiativeStatus.Proposed
        });

        emit InitiativeCreated(initiativeId, location, leader, requiredBudget);
    }

    function directFundInitiative(uint256 initiativeId) external payable {
        FloodInitiative storage init = initiatives[initiativeId];
        require(init.status == InitiativeStatus.Proposed || init.status == InitiativeStatus.Funded, "Initiative not active");
        require(msg.value > 0, "Must send funds");

        init.fundedAmount += msg.value;
        emit DirectFunded(initiativeId, msg.sender, msg.value);

        if (init.fundedAmount >= init.requiredBudget && init.status == InitiativeStatus.Proposed) {
            init.status = InitiativeStatus.Funded;
            
            // Release funds directly to project lead
            (bool success, ) = payable(init.contractorOrLeader).call{value: init.fundedAmount}("");
            require(success, "Payout to lead failed");

            init.status = InitiativeStatus.InProgress;
        }
    }

    function markCompleted(uint256 initiativeId) external onlyOwner {
        FloodInitiative storage init = initiatives[initiativeId];
        require(init.status == InitiativeStatus.InProgress, "Initiative not in progress");

        init.status = InitiativeStatus.Completed;
        trustIntegrator.logPositiveAction(init.contractorOrLeader, 3); // 3 = Community Infrastructure Relief

        emit InitiativeCompleted(initiativeId);
    }
}
