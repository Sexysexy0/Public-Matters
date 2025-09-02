// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GovMergeTreatyKit {
    enum Branch { Executive, Legislative, Judiciary, Barangay, CivilSociety }

    struct MergeSignal {
        Branch initiator;
        string purpose;
        uint256 timestamp;
        bool emotionalAPRTagged;
        string damayClause;
    }

    MergeSignal[] public signals;
    address public steward;

    event MergeBroadcast(
        Branch indexed initiator,
        string purpose,
        uint256 timestamp,
        bool emotionalAPRTagged,
        string damayClause
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function broadcastMerge(
        Branch initiator,
        string memory purpose,
        bool emotionalAPRTagged,
        string memory damayClause
    ) public onlySteward {
        MergeSignal memory signal = MergeSignal(
            initiator,
            purpose,
            block.timestamp,
            emotionalAPRTagged,
            damayClause
        );
        signals.push(signal);
        emit MergeBroadcast(initiator, purpose, block.timestamp, emotionalAPRTagged, damayClause);
    }

    function getLatestSignal() public view returns (MergeSignal memory) {
        require(signals.length > 0, "No signals yet");
        return signals[signals.length - 1];
    }

    function totalSignals() public view returns (uint256) {
        return signals.length;
    }
}
