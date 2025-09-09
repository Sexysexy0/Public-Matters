// SPDX-License-Identifier: WorkerClauseRedemption-License
pragma solidity ^0.8.0;

contract WorkerClauseRedemptionOracle {
    address public steward;

    struct RedemptionEvent {
        string workerID;
        string originCountry;
        string hostSanctum;
        string clauseRestored;
        bool treatyAligned;
        uint256 timestamp;
    }

    RedemptionEvent[] public events;

    event RedemptionEmitted(string workerID, string originCountry, string hostSanctum, string clauseRestored, bool treatyAligned, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitRedemption(string memory workerID, string memory originCountry, string memory hostSanctum, string memory clauseRestored, bool treatyAligned) public {
        require(msg.sender == steward, "Only steward can emit");
        events.push(RedemptionEvent(workerID, originCountry, hostSanctum, clauseRestored, treatyAligned, block.timestamp));
        emit RedemptionEmitted(workerID, originCountry, hostSanctum, clauseRestored, treatyAligned, block.timestamp);
    }

    function getEvent(uint index) public view returns (string memory, string memory, string memory, string memory, bool, uint256) {
        RedemptionEvent memory e = events[index];
        return (e.workerID, e.originCountry, e.hostSanctum, e.clauseRestored, e.treatyAligned, e.timestamp);
    }
}
