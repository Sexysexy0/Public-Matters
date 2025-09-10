// SPDX-License-Identifier: AgriSanctumLabor-License
pragma solidity ^0.8.0;

contract AgriSanctumLaborRouter {
    address public steward;

    struct LaborSignal {
        string region;
        string sector;
        uint256 jobsCreated;
        string visaSupportStatus;
        bool treatyAligned;
        uint256 timestamp;
    }

    LaborSignal[] public signals;

    event LaborRouted(string region, string sector, uint256 jobsCreated, string visaSupportStatus, bool treatyAligned, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeLabor(string memory region, string memory sector, uint256 jobsCreated, string memory visaSupportStatus, bool treatyAligned) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(LaborSignal(region, sector, jobsCreated, visaSupportStatus, treatyAligned, block.timestamp));
        emit LaborRouted(region, sector, jobsCreated, visaSupportStatus, treatyAligned, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, uint256, string memory, bool, uint256) {
        LaborSignal memory s = signals[index];
        return (s.region, s.sector, s.jobsCreated, s.visaSupportStatus, s.treatyAligned, s.timestamp);
    }
}
