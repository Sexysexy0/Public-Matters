// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CounterMechanicsCodex
/// @notice Codex covenant to document counter mechanics against overpowered operators
contract CounterMechanicsCodex {
    address public overseer;
    uint256 public codexCount;

    struct CounterRecord {
        uint256 id;
        string operator;   // target operator (e.g., N-TWO, Uluru)
        string counter;    // gadget, ability, mechanic
        string effect;     // slow, deflect, neutralize, heal
        string notes;      // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => CounterRecord) public records;

    event CounterLogged(uint256 indexed id, string operator, string counter, string effect, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs counter mechanic record
    function logCounter(string calldata operator, string calldata counter, string calldata effect, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = CounterRecord({
            id: codexCount,
            operator: operator,
            counter: counter,
            effect: effect,
            notes: notes,
            timestamp: block.timestamp
        });
        emit CounterLogged(codexCount, operator, counter, effect, notes);
    }

    /// @notice Citizens can view counter mechanic records
    function viewCounter(uint256 id) external view returns (CounterRecord memory) {
        return records[id];
    }
}
