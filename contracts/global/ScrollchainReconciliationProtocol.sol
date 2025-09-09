// SPDX-License-Identifier: ReconciliationProtocol-License
pragma solidity ^0.8.0;

contract ScrollchainReconciliationProtocol {
    address public steward;

    struct ReentryRequest {
        string actor;
        string repentanceClause;
        string restorationPlan;
        bool approved;
        uint256 timestamp;
    }

    ReentryRequest[] public requests;

    event ReentryRequested(string actor, string clause, string plan, bool approved, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function requestReentry(string memory actor, string memory repentanceClause, string memory restorationPlan, bool approved) public {
        require(msg.sender == steward, "Only steward can approve");
        requests.push(ReentryRequest(actor, repentanceClause, restorationPlan, approved, block.timestamp));
        emit ReentryRequested(actor, repentanceClause, restorationPlan, approved, block.timestamp);
    }

    function getRequest(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        ReentryRequest memory r = requests[index];
        return (r.actor, r.repentenceClause, r.restorationPlan, r.approved, r.timestamp);
    }
}
