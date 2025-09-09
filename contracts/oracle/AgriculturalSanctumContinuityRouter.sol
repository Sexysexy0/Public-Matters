// SPDX-License-Identifier: AgriculturalSanctumContinuity-License
pragma solidity ^0.8.0;

contract AgriculturalSanctumContinuityRouter {
    address public steward;

    struct ContinuitySignal {
        string farmID;
        string region;
        bool collapseDetected;
        string stressType;
        uint256 timestamp;
    }

    ContinuitySignal[] public signals;

    event ContinuityRouted(string farmID, string region, bool collapseDetected, string stressType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeContinuity(string memory farmID, string memory region, bool collapseDetected, string memory stressType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ContinuitySignal(farmID, region, collapseDetected, stressType, block.timestamp));
        emit ContinuityRouted(farmID, region, collapseDetected, stressType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ContinuitySignal memory s = signals[index];
        return (s.farmID, s.region, s.collapseDetected, s.stressType, s.timestamp);
    }
}
