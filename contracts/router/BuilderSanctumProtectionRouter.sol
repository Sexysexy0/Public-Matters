// SPDX-License-Identifier: BuilderSanctumProtection-License
pragma solidity ^0.8.0;

contract BuilderSanctumProtectionRouter {
    address public steward;

    struct ProtectionSignal {
        string builderID;
        string threatVector;
        string entityName;
        bool restorationConfirmed;
        string emotionalAPR;
        uint256 timestamp;
    }

    ProtectionSignal[] public signals;

    event BuilderSanctumProtected(string builderID, string threatVector, string entityName, bool restorationConfirmed, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeProtection(string memory builderID, string memory threatVector, string memory entityName, bool restorationConfirmed, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ProtectionSignal(builderID, threatVector, entityName, restorationConfirmed, emotionalAPR, block.timestamp));
        emit BuilderSanctumProtected(builderID, threatVector, entityName, restorationConfirmed, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, string memory, uint256) {
        ProtectionSignal memory s = signals[index];
        return (s.builderID, s.threatVector, s.entityName, s.restorationConfirmed, s.emotionalAPR, s.timestamp);
    }
}
