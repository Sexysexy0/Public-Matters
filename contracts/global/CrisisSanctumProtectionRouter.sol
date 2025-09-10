// SPDX-License-Identifier: CrisisSanctumProtection-License
pragma solidity ^0.8.0;

contract CrisisSanctumProtectionRouter {
    address public steward;

    struct ProtectionSignal {
        string sanctumID;
        string hostNation;
        string threatVector;
        bool kitActivated;
        bool restorationConfirmed;
        uint256 timestamp;
    }

    ProtectionSignal[] public signals;

    event CrisisSanctumProtected(string sanctumID, string hostNation, string threatVector, bool kitActivated, bool restorationConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeProtection(string memory sanctumID, string memory hostNation, string memory threatVector, bool kitActivated, bool restorationConfirmed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ProtectionSignal(sanctumID, hostNation, threatVector, kitActivated, restorationConfirmed, block.timestamp));
        emit CrisisSanctumProtected(sanctumID, hostNation, threatVector, kitActivated, restorationConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        ProtectionSignal memory s = signals[index];
        return (s.sanctumID, s.hostNation, s.threatVector, s.kitActivated, s.restorationConfirmed, s.timestamp);
    }
}
