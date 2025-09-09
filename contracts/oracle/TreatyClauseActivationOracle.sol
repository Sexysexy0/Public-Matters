// SPDX-License-Identifier: TreatyClauseActivation-License
pragma solidity ^0.8.0;

contract TreatyClauseActivationOracle {
    address public steward;

    struct ClauseActivation {
        string clauseID;
        string treatyPartner;
        string sanctumSite;
        bool restorationTriggered;
        bool partnershipAuthorized;
        uint256 timestamp;
    }

    ClauseActivation[] public activations;

    event ClauseActivated(string clauseID, string treatyPartner, string sanctumSite, bool restorationTriggered, bool partnershipAuthorized, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function activateClause(string memory clauseID, string memory treatyPartner, string memory sanctumSite, bool restorationTriggered, bool partnershipAuthorized) public {
        require(msg.sender == steward, "Only steward can activate");
        activations.push(ClauseActivation(clauseID, treatyPartner, sanctumSite, restorationTriggered, partnershipAuthorized, block.timestamp));
        emit ClauseActivated(clauseID, treatyPartner, sanctumSite, restorationTriggered, partnershipAuthorized, block.timestamp);
    }

    function getActivation(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        ClauseActivation memory a = activations[index];
        return (a.clauseID, a.treatyPartner, a.sanctumSite, a.restorationTriggered, a.partnershipAuthorized, a.timestamp);
    }
}
