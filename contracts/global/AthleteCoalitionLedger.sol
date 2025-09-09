// SPDX-License-Identifier: AthleteCoalitionLedger-License
pragma solidity ^0.8.0;

contract AthleteCoalitionLedger {
    address public steward;

    struct AdvocacyPledge {
        string athlete;
        string reformType;
        string rippleZone;
        bool treatySigned;
        uint256 timestamp;
    }

    AdvocacyPledge[] public pledges;

    event AdvocacyPledgeLogged(string athlete, string reform, string zone, bool treaty, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logPledge(string memory athlete, string memory reformType, string memory rippleZone, bool treatySigned) public {
        require(msg.sender == steward, "Only steward can log");
        pledges.push(AdvocacyPledge(athlete, reformType, rippleZone, treatySigned, block.timestamp));
        emit AdvocacyPledgeLogged(athlete, reformType, rippleZone, treatySigned, block.timestamp);
    }

    function getPledge(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        AdvocacyPledge memory p = pledges[index];
        return (p.athlete, p.reformType, p.rippleZone, p.treatySigned, p.timestamp);
    }
}
