// SPDX-License-Identifier: MIT
// Contract Name: AdaptiveWorkflowCharter
// Purpose: Standardize SOPs for promotions, pay raises, and worker feedback
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract AdaptiveWorkflowCharter {
    address public chiefOperator;
    uint256 public workflowCount;

    struct Workflow {
        string processName;       // e.g., Promotion, Pay Raise, Feedback
        string criteria;          // e.g., 6 months performance, attendance
        string guideline;         // SOP details
        uint256 timestamp;
    }

    Workflow[] public workflows;

    event WorkflowAdded(string processName, string criteria, string guideline, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        workflowCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new workflow SOP
    function addWorkflow(string memory processName, string memory criteria, string memory guideline) public onlyChief {
        workflows.push(Workflow(processName, criteria, guideline, block.timestamp));
        workflowCount++;
        emit WorkflowAdded(processName, criteria, guideline, block.timestamp);
    }

    // View workflow details
    function getWorkflow(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < workflows.length, "Invalid workflow index");
        Workflow memory w = workflows[index];
        return (w.processName, w.criteria, w.guideline, w.timestamp);
    }
}
