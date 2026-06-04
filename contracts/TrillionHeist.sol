// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TrillionHeist
/// @notice Covenant contract to log and safeguard against large-scale corruption scandals
contract TrillionHeist {
    address public owner;

    struct HeistRecord {
        string actor;        // e.g. "Agency", "Politician"
        string scheme;       // description of corruption scheme
        uint256 amount;      // stolen or misused funds
        uint256 timestamp;
    }

    HeistRecord[] public records;

    event HeistLogged(string actor, string scheme, uint256 amount, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function logHeist(string memory actor, string memory scheme, uint256 amount) public onlyOwner {
        HeistRecord memory newRecord = HeistRecord(actor, scheme, amount, block.timestamp);
        records.push(newRecord);
        emit HeistLogged(actor, scheme, amount, block.timestamp);
    }

    function getHeist(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        HeistRecord memory h = records[index];
        return (h.actor, h.scheme, h.amount, h.timestamp);
    }

    function getHeistCount() public view returns (uint256) {
        return records.length;
    }
}
