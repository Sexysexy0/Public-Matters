// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PublicBenefitGrant {
    address public guardian;

    struct Grant {
        address institution;
        uint256 totalFunding;
        uint256 remainingFunding;
        string purpose;        // Detalye kung para saan ang pondo (e.g., "Free Education Upgrade")
        bool isCompleted;
        uint256 milestoneCount;
    }

    uint256 public nextGrantId;
    mapping(uint256 => Grant) public grants;
    // Grant ID => Milestone Index => Release Status
    mapping(uint256 => mapping(uint256 => bool)) public milestonesReleased;

    event GrantCreated(uint256 indexed grantId, address indexed institution, uint256 amount);
    event MilestoneApproved(uint256 indexed grantId, uint256 milestoneIndex, uint256 amountReleased);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Only the Guardian can authorize public benefit funds.");
        _;
    }

    constructor() payable {
        guardian = msg.sender;
    }

    // Magpondo ng bagong grant para sa isang karapat-dapat na institusyon
    function createGrant(
        address _institution, 
        string memory _purpose, 
        uint256 _milestones
    ) public payable onlyGuardian {
        require(msg.value > 0, "Grant amount must be greater than zero.");
        require(_milestones > 0, "Grant must have at least one milestone.");

        nextGrantId++;
        grants[nextGrantId] = Grant({
            institution: _institution,
            totalFunding: msg.value,
            remainingFunding: msg.value,
            purpose: _purpose,
            isCompleted: false,
            milestoneCount: _milestones
        });

        emit GrantCreated(nextGrantId, _institution, msg.value);
    }

    // Aprubahan ang pag-release ng pondo kapag nagawa ng institusyon ang kanilang etikal na tungkulin
    function releaseMilestone(uint256 _grantId, uint256 _milestoneIndex) public onlyGuardian {
        Grant storage targetGrant = grants[_grantId];
        require(!targetGrant.isCompleted, "Grant is already fully completed.");
        require(_milestoneIndex < targetGrant.milestoneCount, "Invalid milestone index.");
        require(!milestonesReleased[_grantId][_milestoneIndex], "Milestone already released.");

        uint256 releaseAmount = targetGrant.totalFunding / targetGrant.milestoneCount;
        require(targetGrant.remainingFunding >= releaseAmount, "Insufficient remaining funds.");

        milestonesReleased[_grantId][_milestoneIndex] = true;
        targetGrant.remainingFunding -= releaseAmount;

        if (targetGrant.remainingFunding == 0 || _milestoneIndex == targetGrant.milestoneCount - 1) {
            targetGrant.isCompleted = true;
        }

        payable(targetGrant.institution).transfer(releaseAmount);
        emit MilestoneApproved(_grantId, _milestoneIndex, releaseAmount);
    }

    // Payagan ang Guardian na magdagdag ng pondo sa kabuuang pool ng contract
    receive() external payable {}
}

