// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AccountabilityBridge
/// @notice Encodes automatic penalties for governance failures
contract AccountabilityBridge {
    address public oversightCommittee;
    uint256 public penaltyRate; // e.g. 5% penalty on failed compliance

    struct FailureRecord {
        uint256 id;
        address entity;
        string reason;
        uint256 penaltyAmount;
        uint256 timestamp;
    }

    uint256 public failureCount;
    mapping(uint256 => FailureRecord) public failures;

    event FailureLogged(uint256 indexed id, address indexed entity, string reason, uint256 penaltyAmount);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee, uint256 _penaltyRate) {
        oversightCommittee = _oversightCommittee;
        penaltyRate = _penaltyRate;
    }

    /// @notice Oversight Committee logs governance failure and applies penalty
    function logFailure(address entity, string calldata reason, uint256 baseAmount) external onlyOversight {
        failureCount++;
        uint256 penalty = (baseAmount * penaltyRate) / 100;
        failures[failureCount] = FailureRecord({
            id: failureCount,
            entity: entity,
            reason: reason,
            penaltyAmount: penalty,
            timestamp: block.timestamp
        });
        emit FailureLogged(failureCount, entity, reason, penalty);
    }

    /// @notice Citizens can view failure records
    function viewFailure(uint256 id) external view returns (FailureRecord memory) {
        return failures[id];
    }
}
