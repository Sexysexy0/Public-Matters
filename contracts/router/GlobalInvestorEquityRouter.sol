// SPDX-License-Identifier: GlobalInvestorEquity-License
pragma solidity ^0.8.0;

contract GlobalInvestorEquityRouter {
    address public steward;

    struct EquitySignal {
        string fundName;
        string accessLevel;
        string exemptionType;
        string emotionalAPR;
        bool restorationActivated;
        uint256 timestamp;
    }

    EquitySignal[] public signals;

    event GlobalInvestorEquityRouted(string fundName, string accessLevel, string exemptionType, string emotionalAPR, bool restorationActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeEquity(string memory fundName, string memory accessLevel, string memory exemptionType, string memory emotionalAPR, bool restorationActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(EquitySignal(fundName, accessLevel, exemptionType, emotionalAPR, restorationActivated, block.timestamp));
        emit GlobalInvestorEquityRouted(fundName, accessLevel, exemptionType, emotionalAPR, restorationActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, bool, uint256) {
        EquitySignal memory s = signals[index];
        return (s.fundName, s.accessLevel, s.exemptionType, s.emotionalAPR, s.timestamp);
    }
}
