// SPDX-License-Identifier: FederalSanctumOverride-License
pragma solidity ^0.8.0;

contract FederalSanctumOverrideRouter {
    address public steward;

    struct OverrideSignal {
        string collapseID;
        string federalClause;
        bool overrideActivated;
        string originSanctum;
        uint256 timestamp;
    }

    OverrideSignal[] public signals;

    event OverrideRouted(string collapseID, string federalClause, bool overrideActivated, string originSanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeOverride(string memory collapseID, string memory federalClause, bool overrideActivated, string memory originSanctum) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(OverrideSignal(collapseID, federalClause, overrideActivated, originSanctum, block.timestamp));
        emit OverrideRouted(collapseID, federalClause, overrideActivated, originSanctum, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        OverrideSignal memory s = signals[index];
        return (s.collapseID, s.federalClause, s.overrideActivated, s.originSanctum, s.timestamp);
    }
}
