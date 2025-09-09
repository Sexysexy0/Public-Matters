// SPDX-License-Identifier: TradeDiplomacyClause-License
pragma solidity ^0.8.0;

contract TradeDiplomacyClauseRouter {
    address public steward;

    struct ClauseSignal {
        string licenseID;
        string agency;
        bool clauseConfirmed;
        string sector;
        uint256 timestamp;
    }

    ClauseSignal[] public signals;

    event ClauseRouted(string licenseID, string agency, bool clauseConfirmed, string sector, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeClause(string memory licenseID, string memory agency, bool clauseConfirmed, string memory sector) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ClauseSignal(licenseID, agency, clauseConfirmed, sector, block.timestamp));
        emit ClauseRouted(licenseID, agency, clauseConfirmed, sector, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ClauseSignal memory s = signals[index];
        return (s.licenseID, s.agency, s.clauseConfirmed, s.sector, s.timestamp);
    }
}
