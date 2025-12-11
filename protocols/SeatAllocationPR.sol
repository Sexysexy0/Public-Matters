// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SeatAllocationPR: proportional allocation with threshold and anti-capture exclusion
contract SeatAllocationPR {
    address public steward;

    // votes[partyId] = total votes; seats[partyId] = allocated seats
    mapping(uint256 => uint256) public votes;
    mapping(uint256 => uint256) public seats;
    uint256 public totalVotes;
    uint256 public totalSeats;     // e.g., set by steward
    uint256 public thresholdBP;    // basis points threshold (e.g., 200 = 2%)

    mapping(uint256 => bool) public excluded; // e.g., flagged by AntiCaptureGuard externally

    event VotesSet(uint256 indexed partyId, uint256 votes);
    event ParamsSet(uint256 totalSeats, uint256 thresholdBP);
    event Excluded(uint256 indexed partyId, bool status);
    event Allocated(uint256 indexed partyId, uint256 seats);

    constructor() {
        steward = msg.sender;
        thresholdBP = 200; // default 2%
    }

    function setParams(uint256 _totalSeats, uint256 _thresholdBP) external {
        require(msg.sender == steward, "Only steward");
        totalSeats = _totalSeats;
        thresholdBP = _thresholdBP;
        emit ParamsSet(_totalSeats, _thresholdBP);
    }

    function setVotes(uint256 _partyId, uint256 _votes) external {
        require(msg.sender == steward, "Only steward");
        totalVotes += _votes - votes[_partyId];
        votes[_partyId] = _votes;
        emit VotesSet(_partyId, _votes);
    }

    function setExcluded(uint256 _partyId, bool _status) external {
        require(msg.sender == steward, "Only steward");
        excluded[_partyId] = _status;
        emit Excluded(_partyId, _status);
    }

    function clearAllocations(uint256[] calldata partyIds) external {
        require(msg.sender == steward, "Only steward");
        for (uint256 i = 0; i < partyIds.length; i++) {
            seats[partyIds[i]] = 0;
        }
    }

    // Simple proportional allocation: seats = floor(totalSeats * partyVotes / totalVotes)
    function allocate(uint256[] calldata partyIds) external {
        require(msg.sender == steward, "Only steward");
        uint256 allocatedTotal = 0;

        for (uint256 i = 0; i < partyIds.length; i++) {
            uint256 pid = partyIds[i];
            if (excluded[pid]) {
                seats[pid] = 0;
                emit Allocated(pid, 0);
                continue;
            }
            if (totalVotes == 0) {
                seats[pid] = 0;
                emit Allocated(pid, 0);
                continue;
            }
            // threshold check
            uint256 shareBP = (votes[pid] * 10000) / totalVotes;
            if (shareBP < thresholdBP) {
                seats[pid] = 0;
                emit Allocated(pid, 0);
                continue;
            }
            uint256 s = (totalSeats * votes[pid]) / totalVotes;
            seats[pid] = s;
            allocatedTotal += s;
            emit Allocated(pid, s);
        }

        // Note: rounding may leave unallocated seats; steward can handle remainder externally.
        // This keeps the contract simple and auditable.
    }
}
