// SPDX-License-Identifier: ImmigrationBlessing-License
pragma solidity ^0.8.0;

contract ImmigrationBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string immigrantID;
        string visaCategory;
        string hostNation;
        string disruptionType;
        bool sanctumBlessed;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event ImmigrationBlessingRouted(string immigrantID, string visaCategory, string hostNation, string disruptionType, bool sanctumBlessed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory immigrantID, string memory visaCategory, string memory hostNation, string memory disruptionType, bool sanctumBlessed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(immigrantID, visaCategory, hostNation, disruptionType, sanctumBlessed, block.timestamp));
        emit ImmigrationBlessingRouted(immigrantID, visaCategory, hostNation, disruptionType, sanctumBlessed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.immigrantID, s.visaCategory, s.hostNation, s.disruptionType, s.sanctumBlessed, s.timestamp);
    }
}
