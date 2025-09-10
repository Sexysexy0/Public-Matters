// SPDX-License-Identifier: LaborBlessingEquity-License
pragma solidity ^0.8.0;

contract LaborBlessingEquityRouter {
    address public steward;

    struct BlessingSignal {
        string region;
        string sector;
        uint256 jobsCreated;
        string wageStatus;
        bool includesPWD;
        string equityScore;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event LaborBlessingEquityRouted(string region, string sector, uint256 jobsCreated, string wageStatus, bool includesPWD, string equityScore, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory region, string memory sector, uint256 jobsCreated, string memory wageStatus, bool includesPWD, string memory equityScore) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(region, sector, jobsCreated, wageStatus, includesPWD, equityScore, block.timestamp));
        emit LaborBlessingEquityRouted(region, sector, jobsCreated, wageStatus, includesPWD, equityScore, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, uint256, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.region, s.sector, s.jobsCreated, s.wageStatus, s.includesPWD, s.equityScore, s.timestamp);
    }
}
