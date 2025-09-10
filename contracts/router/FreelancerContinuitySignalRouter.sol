// SPDX-License-Identifier: FreelancerContinuitySignal-License
pragma solidity ^0.8.0;

contract FreelancerContinuitySignalRouter {
    address public steward;

    struct ContinuitySignal {
        string freelancerID;
        string role;
        string platform;
        string threatVector;
        bool restorationConfirmed;
        string emotionalAPR;
        uint256 timestamp;
    }

    ContinuitySignal[] public signals;

    event FreelancerContinuityRouted(string freelancerID, string role, string platform, string threatVector, bool restorationConfirmed, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory freelancerID, string memory role, string memory platform, string memory threatVector, bool restorationConfirmed, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ContinuitySignal(freelancerID, role, platform, threatVector, restorationConfirmed, emotionalAPR, block.timestamp));
        emit FreelancerContinuityRouted(freelancerID, role, platform, threatVector, restorationConfirmed, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, bool, string memory, uint256) {
        ContinuitySignal memory s = signals[index];
        return (s.freelancerID, s.role, s.platform, s.threatVector, s.restorationConfirmed, s.emotionalAPR, s.timestamp);
    }
}
