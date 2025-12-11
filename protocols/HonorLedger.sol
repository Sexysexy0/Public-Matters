// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Honor Ledger Protocol Arc: dignity + consequence entries
contract HonorLedger {
    struct Entry {
        uint256 id;
        address actor;
        string tag;        // e.g., "mercy", "audit", "repair"
        string data;       // short memo or URI
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Entry) public entries;
    mapping(address => bool) public validators;

    address public steward;

    event EntryRecorded(uint256 indexed id, address indexed actor, string tag);
    event ValidatorAdded(address indexed validator);

    constructor() {
        steward = msg.sender;
        validators[steward] = true;
        emit ValidatorAdded(steward);
    }

    function addValidator(address _validator) external {
        require(msg.sender == steward, "Only steward");
        validators[_validator] = true;
        emit ValidatorAdded(_validator);
    }

    function record(string calldata _tag, string calldata _data) external {
        require(validators[msg.sender], "Not validator");
        entries[nextId] = Entry(nextId, msg.sender, _tag, _data, block.timestamp);
        emit EntryRecorded(nextId, msg.sender, _tag);
        nextId++;
    }

    function get(uint256 _id) external view returns (Entry memory) {
        return entries[_id];
    }
}
