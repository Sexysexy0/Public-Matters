// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WorkStrategyBridge
/// @notice Bridge covenant to connect work-solution-strategy focus with orchestration discipline
contract WorkStrategyBridge {
    address public oversightCommittee;
    uint256 public bridgeCount;

    struct StrategyLink {
        uint256 id;
        string domain;       // e.g. tech, governance, creative
        string focus;        // work, solution, strategy
        string discipline;   // professional, lawful, aligned
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => StrategyLink) public links;

    event StrategyLinked(uint256 indexed id, string domain, string focus, string discipline, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight links work-strategy focus to orchestration discipline
    function linkStrategy(string calldata domain, string calldata focus, string calldata discipline, string calldata notes) external onlyOversight {
        bridgeCount++;
        links[bridgeCount] = StrategyLink({
            id: bridgeCount,
            domain: domain,
            focus: focus,
            discipline: discipline,
            notes: notes,
            timestamp: block.timestamp
        });
        emit StrategyLinked(bridgeCount, domain, focus, discipline, notes);
    }

    /// @notice Citizens can view strategy links
    function viewLink(uint256 id) external view returns (StrategyLink memory) {
        return links[id];
    }
}
