// ProactiveAgentLogic.sol
// Logic: Initiative Scoring
pragma solidity ^0.8.0;

contract ProactiveAgentLogic {
    mapping(address => uint256) public initiativePoints;

    function recordProactiveAction(address _leader, string memory _actionType) public {
        // Goal: Transform Supervisors into Change Agents.
        // Rewards for identifying a problem AND fixing it without supervision.
        initiativePoints[_leader] += 10;
    }
}
