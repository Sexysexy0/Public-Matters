// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EthicsGuardian
/// @notice Safeguard against abuse of power in governance
contract EthicsGuardian {
    address public oversightCommittee;
    uint256 public violationCount;

    struct Violation {
        uint256 id;
        address violator;
        string principleBreached; // e.g. abuse of authority, corruption, negligence
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Violation) public violations;

    event ViolationLogged(uint256 indexed id, address indexed violator, string principle, string details);
    event EthicsAlert(address indexed violator, string principle);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight Committee logs ethical violations
    function logViolation(address violator, string calldata principle, string calldata details) external onlyOversight {
        violationCount++;
        violations[violationCount] = Violation({
            id: violationCount,
            violator: violator,
            principleBreached: principle,
            details: details,
            timestamp: block.timestamp
        });
        emit ViolationLogged(violationCount, violator, principle, details);
        emit EthicsAlert(violator, principle);
    }

    /// @notice Citizens can view violations
    function viewViolation(uint256 id) external view returns (Violation memory) {
        return violations[id];
    }
}
