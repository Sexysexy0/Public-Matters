// SPDX-License-Identifier: GlobalLaborContinuity-License
pragma solidity ^0.8.0;

contract GlobalLaborContinuityRouter {
    address public steward;

    struct ContinuitySignal {
        string workerID;
        string projectScope;
        bool treatyAligned;
        bool restorationActivated;
        uint256 timestamp;
    }

    ContinuitySignal[] public signals;

    event LaborContinuityRouted(string workerID, string projectScope, bool treatyAligned, bool restorationActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeContinuity(string memory workerID, string memory projectScope, bool treatyAligned, bool restorationActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ContinuitySignal(workerID, projectScope, treatyAligned, restorationActivated, block.timestamp));
        emit LaborContinuityRouted(workerID, projectScope, treatyAligned, restorationActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, bool, uint256) {
        ContinuitySignal memory s = signals[index];
        return (s.workerID, s.projectScope, s.treatyAligned, s.restorationActivated, s.timestamp);
    }
}
