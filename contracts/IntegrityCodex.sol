// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntegrityCodex
/// @notice Covenant to safeguard ethical governance,
///         ensuring honesty, accountability, and transparency.
contract IntegrityCodex {
    address public overseer;
    uint256 public codexCount;

    struct Codex {
        uint256 id;
        string principle;   // Honesty, Accountability, Transparency, Ethics
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Codex) public codices;

    event CodexDeclared(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareCodex(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        codices[codexCount] = Codex(codexCount, principle, description, block.timestamp);
        emit CodexDeclared(codexCount, principle, description);
    }

    function viewCodex(uint256 id) external view returns (Codex memory) {
        return codices[id];
    }
}
