// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReferendumBlessingRouter {
    enum RegionStatus { Passive, Debated, Active }
    enum VoteOutcome { Pending, Approved, Rejected }

    struct Referendum {
        uint256 id;
        string region;
        string targetAlignment;
        RegionStatus status;
        VoteOutcome outcome;
        uint256 scheduledYear;
        string clauseReference;
    }

    mapping(uint256 => Referendum) public referendumRegistry;
    uint256 public referendumCount;

    event ReferendumLogged(uint256 id, string region, VoteOutcome outcome);
    event BlessingActivated(uint256 id, string message);

    function logReferendum(
        string memory region,
        string memory targetAlignment,
        RegionStatus status,
        VoteOutcome outcome,
        uint256 scheduledYear,
        string memory clauseReference
    ) public {
        referendumRegistry[referendumCount] = Referendum(
            referendumCount,
            region,
            targetAlignment,
            status,
            outcome,
            scheduledYear,
            clauseReference
        );
        emit ReferendumLogged(referendumCount, region, outcome);
        referendumCount++;
    }

    function activateBlessing(uint256 id) public returns (string memory message) {
        require(id < referendumCount, "Invalid referendum ID");
        Referendum memory ref = referendumRegistry[id];

        if (ref.outcome == VoteOutcome.Approved) {
            emit BlessingActivated(id, "Referendum approved – sovereignty ritual initiated");
            return "Referendum approved – sovereignty ritual initiated";
        } else if (ref.outcome == VoteOutcome.Rejected) {
            emit BlessingActivated(id, "Referendum rejected – treaty status retained");
            return "Referendum rejected – treaty status retained";
        } else {
            emit BlessingActivated(id, "Referendum pending – ceremonial vote required");
            return "Referendum pending – ceremonial vote required";
        }
    }

    function getReferendum(uint256 id) public view returns (Referendum memory) {
        return referendumRegistry[id];
    }
}
