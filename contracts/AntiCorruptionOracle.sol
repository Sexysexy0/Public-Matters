// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AntiCorruptionOracle
/// @notice Covenant contract to flag unexplained wealth and suspicious transactions
contract AntiCorruptionOracle {
    address public owner;

    struct Flag {
        address suspect;
        string reason;       // e.g. "Unexplained Wealth", "Suspicious Allocation"
        uint256 amount;      // value flagged
        uint256 timestamp;
    }

    Flag[] public flags;

    event Flagged(address suspect, string reason, uint256 amount, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Flag a suspicious transaction or wealth record
    function flagSuspect(address suspect, string memory reason, uint256 amount) public onlyOwner {
        Flag memory newFlag = Flag(suspect, reason, amount, block.timestamp);
        flags.push(newFlag);
        emit Flagged(suspect, reason, amount, block.timestamp);
    }

    function getFlag(uint256 index) public view returns (address, string memory, uint256, uint256) {
        Flag memory f = flags[index];
        return (f.suspect, f.reason, f.amount, f.timestamp);
    }

    function getFlagCount() public view returns (uint256) {
        return flags.length;
    }
}
