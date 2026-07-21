// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EconomicWisdomCodex
/// @notice Covenant contract encoding five pillars of economic wisdom
/// @dev Inspired by Dr. David Henderson's lecture on Free Market Economics
contract EconomicWisdomCodex {
    address public sovereignContractor;

    struct Pillar {
        uint256 id;
        string principle;   // e.g. "Tanstaafl", "Incentives Matter"
        string description; // short explanation
        bool accredited;
    }

    mapping(uint256 => Pillar) public pillars;
    uint256 public totalPillars;

    event PillarLogged(uint256 indexed id, string principle, string description, bool accredited);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    /// @notice Register a new economic pillar
    function registerPillar(string memory _principle, string memory _description) public onlyContractor returns (uint256) {
        totalPillars++;
        pillars[totalPillars] = Pillar({
            id: totalPillars,
            principle: _principle,
            description: _description,
            accredited: true
        });

        emit PillarLogged(totalPillars, _principle, _description, true);
        return totalPillars;
    }

    /// @notice Fetch pillar details
    function getPillar(uint256 id) public view returns (Pillar memory) {
        return pillars[id];
    }
}
