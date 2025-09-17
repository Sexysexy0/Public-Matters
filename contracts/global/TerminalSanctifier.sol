// SPDX-License-Identifier: TerminalSanctum
pragma solidity ^0.8.19;

contract TerminalSanctifier {
    address public steward;

    struct CommandEvent {
        string user;
        string terminalType; // e.g. "PowerShell", "Bash", "CMD"
        string commandSample;
        bool sanctified;
        string sourceTag; // e.g. "Internal Script", "Clipboard Injection", "Phishing Site"
        uint256 timestamp;
    }

    CommandEvent[] public events;

    event CommandLogged(string user, string terminalType, string commandSample, string sourceTag, uint256 timestamp);
    event CommandSanctified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logCommand(
        string memory user,
        string memory terminalType,
        string memory commandSample,
        string memory sourceTag
    ) public {
        events.push(CommandEvent(user, terminalType, commandSample, false, sourceTag, block.timestamp));
        emit CommandLogged(user, terminalType, commandSample, sourceTag, block.timestamp);
    }

    function sanctifyCommand(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].sanctified = true;
        emit CommandSanctified(index, msg.sender);
    }

    function getCommand(uint256 index) public view returns (
        string memory, string memory, string memory, bool, string memory, uint256
    ) {
        CommandEvent memory c = events[index];
        return (c.user, c.terminalType, c.commandSample, c.sanctified, c.sourceTag, c.timestamp);
    }

    function totalCommands() public view returns (uint256) {
        return events.length;
    }
}
