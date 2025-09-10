// SPDX-License-Identifier: TreatyApology-License
pragma solidity ^0.8.0;

contract TreatyApologyRouter {
    address public steward;

    struct ApologySignal {
        string disruptionType;
        string hostNation;
        string sanctumID;
        bool apologyDelivered;
        bool restorationActivated;
        uint256 timestamp;
    }

    ApologySignal[] public signals;

    event TreatyApologyRouted(string disruptionType, string hostNation, string sanctumID, bool apologyDelivered, bool restorationActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeApology(string memory disruptionType, string memory hostNation, string memory sanctumID, bool apologyDelivered, bool restorationActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ApologySignal(disruptionType, hostNation, sanctumID, apologyDelivered, restorationActivated, block.timestamp));
        emit TreatyApologyRouted(disruptionType, hostNation, sanctumID, apologyDelivered, restorationActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        ApologySignal memory s = signals[index];
        return (s.disruptionType, s.hostNation, s.sanctumID, s.apologyDelivered, s.restorationActivated, s.timestamp);
    }
}
