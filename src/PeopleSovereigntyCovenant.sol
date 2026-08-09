// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IEndowmentGovernor {
    function disburse(address _to, uint256 _amount) external;
}

/**
 * @title PeopleSovereigntyCovenant
 * @dev On-chain implementation of Kara David's lyrics, ensuring basic human rights are actionable.
 */
contract PeopleSovereigntyCovenant {
    address public immutable owner;
    IEndowmentGovernor public endowment;

    bool public elsaAtLandoIsPeaceful;
    bool public magdaIsFree;
    bool public sirenaIsAccepted;
    bool public walangNatiraHasHome;
    bool public simplengTaoHasFairLife;
    bool public upuanHasReturned;

    event SocialGoalUpdated(string goalName, bool status, uint256 timestamp);
    event GrantReleased(string goalName, address indexed recipient, uint256 amount);
    event EndowmentUpdated(address newEndowment);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the Architect");
        _;
    }

    constructor(address _endowment) {
        owner = msg.sender;
        endowment = IEndowmentGovernor(_endowment);
    }

    function setEndowment(address _endowment) external onlyOwner {
        endowment = IEndowmentGovernor(_endowment);
        emit EndowmentUpdated(_endowment);
    }

    function grantPeace(address _recipient, uint256 _amount) external onlyOwner {
        elsaAtLandoIsPeaceful = true;
        emit SocialGoalUpdated("Elsa at Lando (Peace)", true, block.timestamp);
        endowment.disburse(_recipient, _amount);
        emit GrantReleased("Peace & Stability Fund", _recipient, _amount);
    }

    function grantFreedom() external onlyOwner {
        magdaIsFree = true;
        emit SocialGoalUpdated("Magda (Freedom)", true, block.timestamp);
    }

    function grantAcceptance() external onlyOwner {
        sirenaIsAccepted = true;
        emit SocialGoalUpdated("Sirena (Acceptance)", true, block.timestamp);
    }

    function grantHousing(address _recipient, uint256 _amount) external onlyOwner {
        walangNatiraHasHome = true;
        emit SocialGoalUpdated("Walang Natira (Housing)", true, block.timestamp);
        endowment.disburse(_recipient, _amount);
        emit GrantReleased("Housing Construction Fund", _recipient, _amount);
    }

    function grantFairLife() external onlyOwner {
        simplengTaoHasFairLife = true;
        emit SocialGoalUpdated("Simpleng Tao (Fairness)", true, block.timestamp);
    }

    function grantRepatriation() external onlyOwner {
        upuanHasReturned = true;
        emit SocialGoalUpdated("Upuan (Repatriation)", true, block.timestamp);
    }
}
