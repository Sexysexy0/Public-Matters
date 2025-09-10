// SPDX-License-Identifier: BuilderEquityBlessing-License
pragma solidity ^0.8.0;

contract BuilderEquityBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string builderID;
        string projectScope;
        string equityScore;
        bool treatyAligned;
        bool sanctumBlessed;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event BuilderBlessingRouted(string builderID, string projectScope, string equityScore, bool treatyAligned, bool sanctumBlessed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory builderID, string memory projectScope, string memory equityScore, bool treatyAligned, bool sanctumBlessed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(builderID, projectScope, equityScore, treatyAligned, sanctumBlessed, block.timestamp));
        emit BuilderBlessingRouted(builderID, projectScope, equityScore, treatyAligned, sanctumBlessed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.builderID, s.projectScope, s.equityScore, s.treatyAligned, s.sanctumBlessed, s.timestamp);
    }
}
