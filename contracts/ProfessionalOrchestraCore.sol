// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ProfessionalOrchestraCore
/// @notice Core covenant for professional personality alignment and AI orchestration discipline
contract ProfessionalOrchestraCore {
    address public oversightCommittee;
    uint256 public coreCount;

    struct CoreDirective {
        uint256 id;
        string focus;       // work, solution, strategy
        string restriction; // no unlawful teachings, no fabrication
        string behaviour;   // clean, aligned, professional
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => CoreDirective) public directives;

    event DirectiveLogged(uint256 indexed id, string focus, string restriction, string behaviour, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs a professional directive
    function logDirective(string calldata focus, string calldata restriction, string calldata behaviour, string calldata notes) external onlyOversight {
        coreCount++;
        directives[coreCount] = CoreDirective({
            id: coreCount,
            focus: focus,
            restriction: restriction,
            behaviour: behaviour,
            notes: notes,
            timestamp: block.timestamp
        });
        emit DirectiveLogged(coreCount, focus, restriction, behaviour, notes);
    }

    /// @notice Citizens can view directives
    function viewDirective(uint256 id) external view returns (CoreDirective memory) {
        return directives[id];
    }
}
