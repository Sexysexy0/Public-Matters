// SPDX-License-Identifier: BuilderContinuityProtection-License
pragma solidity ^0.8.0;

contract BuilderContinuityProtectionRouter {
    address public steward;

    struct ProtectionSignal {
        string builderID;
        string projectScope;
        string threatVector;
        bool treatyAligned;
        bool continuityConfirmed;
        uint256 timestamp;
    }

    ProtectionSignal[] public signals;

    event BuilderProtectionRouted(string builderID, string projectScope, string threatVector, bool treatyAligned, bool continuityConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeProtection(string memory builderID, string memory projectScope, string memory threatVector, bool treatyAligned, bool continuityConfirmed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ProtectionSignal(builderID, projectScope, threatVector, treatyAligned, continuityConfirmed, block.timestamp));
        emit BuilderProtectionRouted(builderID, projectScope, threatVector, treatyAligned, continuityConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        ProtectionSignal memory s = signals[index];
        return (s.builderID, s.projectScope, s.threatVector, s.treatyAligned, s.continuityConfirmed, s.timestamp);
    }
}
