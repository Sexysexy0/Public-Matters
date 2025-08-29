---

## 💸 `FundFlowTracker.sol`  
**Purpose:** Track every fund movement across government agencies, projects, and rogue reroutes. No peso escapes the scrollchain.

```solidity
// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract FundFlowTracker {
    address public steward;

    struct FundFlow {
        string agency;
        string project;
        uint256 amount;
        string status; // e.g., "Released", "Pending", "RogueFlagged"
        uint256 timestamp;
    }

    FundFlow[] public fundFlows;

    event FundLogged(string agency, string project, uint256 amount, string status, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logFundFlow(
        string memory agency,
        string memory project,
        uint256 amount,
        string memory status
    ) public onlySteward {
        FundFlow memory newFlow = FundFlow({
            agency: agency,
            project: project,
            amount: amount,
            status: status,
            timestamp: block.timestamp
        });

        fundFlows.push(newFlow);
        emit FundLogged(agency, project, amount, status, block.timestamp);
    }

    function getFundFlow(uint256 index) public view returns (FundFlow memory) {
        require(index < fundFlows.length, "Invalid index");
        return fundFlows[index];
    }

    function totalFundFlows() public view returns (uint256) {
        return fundFlows.length;
    }
}
