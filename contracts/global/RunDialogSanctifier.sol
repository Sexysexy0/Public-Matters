// SPDX-License-Identifier: DialogSanctum
pragma solidity ^0.8.19;

contract RunDialogSanctifier {
    address public steward;

    struct RunEvent {
        string user;
        string command;
        string sourceTag; // e.g. "Clipboard Injection", "Internal Script", "Phishing Site"
        bool sanctified;
        uint256 timestamp;
    }

    RunEvent[] public events;

    event RunLogged(string user, string command, string sourceTag, uint256 timestamp);
    event RunSanctified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logRun(
        string memory user,
        string memory command,
        string memory sourceTag
    ) public {
        events.push(RunEvent(user, command, sourceTag, false, block.timestamp));
        emit RunLogged(user, command, sourceTag, block.timestamp);
    }

    function sanctifyRun(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].sanctified = true;
        emit RunSanctified(index, msg.sender);
    }

    function getRun(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        RunEvent memory r = events[index];
        return (r.user, r.command, r.sourceTag, r.sanctified, r.timestamp);
    }

    function totalRuns() public view returns (uint256) {
        return events.length;
    }
}
