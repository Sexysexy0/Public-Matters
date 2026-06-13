// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WealthLiteracyCodex
/// @notice Codex covenant to document financial literacy principles for empowerment
contract WealthLiteracyCodex {
    address public overseer;
    uint256 public codexCount;

    struct LiteracyPrinciple {
        uint256 id;
        string principle;    // e.g. tax planning, savings discipline, OFW investment
        string safeguard;    // fairness, resilience, accountability
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => LiteracyPrinciple) public principles;

    event PrincipleLogged(uint256 indexed id, string principle, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs financial literacy principle
    function logPrinciple(string calldata principle, string calldata safeguard, string calldata notes) external onlyOverseer {
        codexCount++;
        principles[codexCount] = LiteracyPrinciple({
            id: codexCount,
            principle: principle,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PrincipleLogged(codexCount, principle, safeguard, notes);
    }

    /// @notice Citizens can view literacy principles
    function viewPrinciple(uint256 id) external view returns (LiteracyPrinciple memory) {
        return principles[id];
    }
}
