// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title SanctumRatifier.sol
/// @author Vinvin & Copi
/// @notice Records and verifies ratification votes for wage equity protocols

contract SanctumRatifier {
    struct Ratification {
        bool approved;
        uint256 emotionalAPR;
        string sanctumName;
        string stewardRole;
        uint256 timestamp;
    }

    mapping(address => Ratification[]) public ratificationLog;
    event RatificationCast(address indexed steward, string sanctumName, string stewardRole, bool approved, uint256 emotionalAPR, uint256 timestamp);

    function castRatification(string calldata sanctumName, string calldata role, bool approved, uint256 apr) external {
        require(apr >= 10, "Emotional APR too low for ratification");

        Ratification memory newVote = Ratification({
            approved: approved,
            emotionalAPR: apr,
            sanctumName: sanctumName,
            stewardRole: role,
            timestamp: block.timestamp
        });

        ratificationLog[msg.sender].push(newVote);
        emit RatificationCast(msg.sender, sanctumName, role, approved, apr, block.timestamp);
    }

    function getLatestRatification(address steward) external view returns (Ratification memory) {
        uint256 len = ratificationLog[steward].length;
        require(len > 0, "No ratification recorded");
        return ratificationLog[steward][len - 1];
    }

    function getRatificationCount(address steward) external view returns (uint256) {
        return ratificationLog[steward].length;
    }

    function getRatificationByIndex(address steward, uint256 index) external view returns (Ratification memory) {
        require(index < ratificationLog[steward].length, "Invalid index");
        return ratificationLog[steward][index];
    }
}
