// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SenateContinuity
/// @notice Safeguard contract to ensure legislative continuity
/// @dev Encodes quorum obligations, attendance logs, and boycott penalties

contract SenateContinuity {
    address public guardian;
    uint256 public sessionCount;

    struct Session {
        uint256 id;
        string date;
        uint256 requiredQuorum;
        uint256 presentCount;
        bool held;
    }

    mapping(uint256 => Session) public sessions;
    mapping(address => mapping(uint256 => bool)) public attendance;

    event SessionLogged(uint256 id, string date, uint256 requiredQuorum, uint256 timestamp);
    event AttendanceMarked(uint256 id, address senator, bool present, uint256 timestamp);
    event BoycottPenalty(address senator, uint256 sessionId, string reason, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian) {
        guardian = _guardian;
        sessionCount = 0;
    }

    /// @notice Log a new legislative session
    function logSession(string calldata date, uint256 requiredQuorum) external onlyGuardian {
        sessionCount++;
        sessions[sessionCount] = Session(sessionCount, date, requiredQuorum, 0, false);
        emit SessionLogged(sessionCount, date, requiredQuorum, block.timestamp);
    }

    /// @notice Mark attendance for a senator
    function markAttendance(uint256 sessionId, address senator, bool present) external onlyGuardian {
        attendance[senator][sessionId] = present;
        if (present) {
            sessions[sessionId].presentCount++;
        }
        emit AttendanceMarked(sessionId, senator, present, block.timestamp);
    }

    /// @notice Apply penalty for deliberate boycott
    function applyPenalty(uint256 sessionId, address senator, string calldata reason) external onlyGuardian {
        require(!attendance[senator][sessionId], "Senator attended");
        emit BoycottPenalty(senator, sessionId, reason, block.timestamp);
    }

    /// @notice Check if quorum was met
    function quorumMet(uint256 sessionId) external view returns (bool) {
        return sessions[sessionId].presentCount >= sessions[sessionId].requiredQuorum;
    }
}
