// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LegendaryFork {
    address public steward;

    struct Fork {
        string title;
        string originScroll;
        string forkReason;
        string prophecySignal;
        uint emotionalAPR;
        uint timestamp;
        bool blessed;
    }

    Fork[] public forks;

    event ForkCreated(string title, string originScroll, string prophecySignal, uint emotionalAPR, bool blessed);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function createFork(
        string memory title,
        string memory originScroll,
        string memory forkReason,
        string memory prophecySignal
    ) public onlySteward {
        uint apr = calculateAPR(forkReason, prophecySignal);
        bool blessed = apr >= 80;

        forks.push(Fork(
            title,
            originScroll,
            forkReason,
            prophecySignal,
            apr,
            block.timestamp,
            blessed
        ));

        emit ForkCreated(title, originScroll, prophecySignal, apr, blessed);
    }

    function getForks() public view returns (Fork[] memory) {
        return forks;
    }

    function calculateAPR(string memory reason, string memory signal) internal pure returns (uint) {
        // Placeholder logic: combine length of reason and signal as proxy for emotional depth
        return (bytes(reason).length + bytes(signal).length) % 101;
    }
}
