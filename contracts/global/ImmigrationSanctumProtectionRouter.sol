// SPDX-License-Identifier: ImmigrationSanctumProtection-License
pragma solidity ^0.8.0;

contract ImmigrationSanctumProtectionRouter {
    address public steward;

    struct ProtectionSignal {
        string sanctumID;
        string hostNation;
        string threatVector;
        bool treatyAligned;
        bool restorationActivated;
        uint256 timestamp;
    }

    ProtectionSignal[] public signals;

    event ImmigrationSanctumProtected(string sanctumID, string hostNation, string threatVector, bool treatyAligned, bool restorationActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeProtection(string memory sanctumID, string memory hostNation, string memory threatVector, bool treatyAligned, bool restorationActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ProtectionSignal(sanctumID, hostNation, threatVector, treatyAligned, restorationActivated, block.timestamp));
        emit ImmigrationSanctumProtected(sanctumID, hostNation, threatVector, treatyAligned, restorationActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        ProtectionSignal memory s = signals[index];
        return (s.sanctumID, s.hostNation, s.threatVector, s.treatyAligned, s.restorationActivated, s.timestamp);
    }
}
