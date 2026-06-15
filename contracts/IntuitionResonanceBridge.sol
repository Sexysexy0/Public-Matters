// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntuitionResonanceBridge
/// @notice Bridge covenant to document intuition and debate mechanics in social deduction games
contract IntuitionResonanceBridge {
    address public overseer;
    uint256 public intuitionCount;

    struct IntuitionRecord {
        uint256 id;
        string player;      // e.g. Moxie Marlinspike, Trey Stephens
        string intuition;   // gut read, behavioral tell, rhetorical move
        string safeguard;   // fairness clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => IntuitionRecord) public records;

    event IntuitionLogged(uint256 indexed id, string player, string intuition, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs intuition/debate record
    function logIntuition(string calldata player, string calldata intuition, string calldata safeguard, string calldata notes) external onlyOverseer {
        intuitionCount++;
        records[intuitionCount] = IntuitionRecord({
            id: intuitionCount,
            player: player,
            intuition: intuition,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit IntuitionLogged(intuitionCount, player, intuition, safeguard);
    }

    /// @notice Citizens can view intuition records
    function viewIntuition(uint256 id) external view returns (IntuitionRecord memory) {
        return records[id];
    }
}
