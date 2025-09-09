// SPDX-License-Identifier: PublicHiringContinuityPledge-License
pragma solidity ^0.8.0;

contract PublicHiringContinuityPledgeOracle {
    address public steward;

    struct PledgeSignal {
        string agencyID;
        string region;
        bool pledgeConfirmed;
        string clauseType;
        uint256 timestamp;
    }

    PledgeSignal[] public signals;

    event HiringPledgeEmitted(string agencyID, string region, bool pledgeConfirmed, string clauseType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPledge(string memory agencyID, string memory region, bool pledgeConfirmed, string memory clauseType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(PledgeSignal(agencyID, region, pledgeConfirmed, clauseType, block.timestamp));
        emit HiringPledgeEmitted(agencyID, region, pledgeConfirmed, clauseType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        PledgeSignal memory s = signals[index];
        return (s.agencyID, s.region, s.pledgeConfirmed, s.clauseType, s.timestamp);
    }
}
