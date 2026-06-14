// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CareerFallLedger
/// @notice Ledger covenant to document collapse of career and personal life after whistleblowing
contract CareerFallLedger {
    address public overseer;
    uint256 public entryCount;

    struct FallRecord {
        uint256 id;
        string loss;        // career, pension, marriage
        string cause;       // retaliation, prosecution, moral stand
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => FallRecord) public records;

    event FallLogged(uint256 indexed id, string loss, string cause);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs career fall record
    function logFall(string calldata loss, string calldata cause, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = FallRecord({
            id: entryCount,
            loss: loss,
            cause: cause,
            notes: notes,
            timestamp: block.timestamp
        });
        emit FallLogged(entryCount, loss, cause);
    }

    /// @notice Citizens can view career fall records
    function viewFall(uint256 id) external view returns (FallRecord memory) {
        return records[id];
    }
}
