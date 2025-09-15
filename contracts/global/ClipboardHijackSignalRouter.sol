// SPDX-License-Identifier: ClipperSanctum
pragma solidity ^0.8.19;

contract ClipboardHijackSignalRouter {
    struct ClipperSignal {
        string clipboardHash;
        string suspectedAddress;
        string originalAddress;
        uint256 deviationScore;
        bool quarantineTriggered;
        string stewardNote;
    }

    mapping(string => ClipperSignal) public signals;

    event SignalTagged(string clipboardHash, string suspectedAddress);
    event QuarantineActivated(string clipboardHash);

    function tagSignal(string memory clipboardHash, string memory suspectedAddress, string memory originalAddress, uint256 deviationScore, string memory stewardNote) public {
        signals[clipboardHash] = ClipperSignal(clipboardHash, suspectedAddress, originalAddress, deviationScore, false, stewardNote);
        emit SignalTagged(clipboardHash, suspectedAddress);
    }

    function activateQuarantine(string memory clipboardHash) public {
        require(signals[clipboardHash].deviationScore >= 75, "Deviation not critical");
        signals[clipboardHash].quarantineTriggered = true;
        emit QuarantineActivated(clipboardHash);
    }

    function getSignalStatus(string memory clipboardHash) public view returns (ClipperSignal memory) {
        return signals[clipboardHash];
    }
}
