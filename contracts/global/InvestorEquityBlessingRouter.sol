// SPDX-License-Identifier: InvestorEquityBlessing-License
pragma solidity ^0.8.0;

contract InvestorEquityBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string investorID;
        string projectScope;
        string sanctumID;
        string equityScore;
        bool restorationActivated;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event InvestorBlessingRouted(string investorID, string projectScope, string sanctumID, string equityScore, bool restorationActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory investorID, string memory projectScope, string memory sanctumID, string memory equityScore, bool restorationActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(investorID, projectScope, sanctumID, equityScore, restorationActivated, block.timestamp));
        emit InvestorBlessingRouted(investorID, projectScope, sanctumID, equityScore, restorationActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.investorID, s.projectScope, s.sanctumID, s.equityScore, s.restorationActivated, s.timestamp);
    }
}
