// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignTreasuryProtocol {
    
    address public immutable solicitorGeneral;

    enum ProjectStatus { OPEN_FOR_BIDDING, IN_PROGRESS, COMPLETED, FLAGGED }

    struct Project {
        string projectName;
        uint256 totalBudget;
        address awardedContractor;
        uint256 milestonesCompleted;
        uint256 totalMilestones;
        ProjectStatus status;
    }

    mapping(uint256 => Project) public publicWorks;
    uint256 public nextProjectId;

    event ProjectCreated(uint256 projectId, string name, uint256 budget);
    event ContractAwarded(uint256 projectId, address contractor);
    event MilestonePaid(uint256 projectId, uint256 milestoneNumber, uint256 amountReleased);
    event ProjectFlagged(uint256 projectId, string reason);

    constructor() {
        solicitorGeneral = msg.sender; // Ang OSG bilang Ultimate Auditor
    }

    modifier onlyOSG() {
        require(msg.sender == solicitorGeneral, "Execution Denied: Root Admin/OSG only.");
        _;
    }

    /**
     * @dev Step 1: I-re-register ang public project. Nakikita ng lahat ng mamamayan sa blockchain.
     * Nakapasok na agad ang pondo sa Smart Contract (Escrow). Hindi ito pwedeng withdraw-hin ng pulitiko.
     */
    function createProject(string memory _name, uint256 _totalMilestones) external payable onlyOSG {
        require(msg.value > 0, "Project must be fully funded upon creation.");
        
        publicWorks[nextProjectId] = Project({
            projectName: _name,
            totalBudget: msg.value,
            awardedContractor: address(0),
            milestonesCompleted: 0,
            totalMilestones: _totalMilestones,
            status: ProjectStatus.OPEN_FOR_BIDDING
        });

        emit ProjectCreated(nextProjectId, _name, msg.value);
        nextProjectId++;
    }

    /**
     * @dev Step 2: Ang pag-award ng kontrata.
     */
    function awardProject(uint256 _projectId, address _contractor) external onlyOSG {
        Project storage p = publicWorks[_projectId];
        require(p.status == ProjectStatus.OPEN_FOR_BIDDING, "Project not open for bidding.");
        
        p.awardedContractor = _contractor;
        p.status = ProjectStatus.IN_PROGRESS;

        emit ContractAwarded(_projectId, _contractor);
    }

    /**
     * @dev Step 3: Ang Anti-Ghost Project System.
     * Ire-release lang ang pondo kada milestone na natapos (e.g., 25% tapos, 25% bayad).
     * Kailangan ng OSG clearance (o Validator Oracle) bago ma-release.
     */
    function approveMilestoneAndPay(uint256 _projectId) external onlyOSG {
        Project storage p = publicWorks[_projectId];
        require(p.status == ProjectStatus.IN_PROGRESS, "Project is not in progress.");
        require(p.milestonesCompleted < p.totalMilestones, "All milestones already completed.");

        // I-calculate ang ibabayad (Total Budget / Total Milestones)
        uint256 payoutAmount = p.totalBudget / p.totalMilestones;
        p.milestonesCompleted++;

        // I-release ang pera diretso sa contractor, walang dadaanang pulitiko.
        (bool success, ) = p.awardedContractor.call{value: payoutAmount}(""); require(success, "ETH transfer failed");
        emit MilestonePaid(_projectId, p.milestonesCompleted, payoutAmount);

        // Kung tapos na lahat ng milestones, mark as COMPLETED
        if (p.milestonesCompleted == p.totalMilestones) {
            p.status = ProjectStatus.COMPLETED;
        }
    }

    /**
     * @dev Step 4: The Red Tape & Corruption Guillotine.
     * Kapag may nag-report ng substandard na materyales o ghost project, i-fa-flag ng OSG.
     * Ang natitirang pondo ay mafa-freeze at hindi na makukuha ng contractor.
     */
    function flagCorruptProject(uint256 _projectId, string memory _reason) external onlyOSG {
        Project storage p = publicWorks[_projectId];
        p.status = ProjectStatus.FLAGGED;
        
        emit ProjectFlagged(_projectId, _reason);
    }
}
