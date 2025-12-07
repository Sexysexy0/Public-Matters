// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Codex: Transparency Diagnostics IV — open diagnostics, no subscription chokehold
 */
contract TransparencyDiagnosticsCodexIV {
    address public steward;
    uint256 public version = 1321_9_261;

    struct Diagnostic {
        string code;      // e.g., "P0123"
        string summary;   // short human-readable
        string remedy;    // open repair guidance
        uint256 timestamp;
    }

    // assetKey => diagnostics list
    mapping(bytes32 => Diagnostic[]) public logs;

    event DiagnosticLogged(bytes32 indexed assetKey, string code, string summary, string remedy);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function keyFor(string memory vinOrId) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(vinOrId));
    }

    // Seal: Transparent logging (on-chain reference to open info)
    function logDiagnostic(
        string calldata vinOrId,
        string calldata code,
        string calldata summary,
        string calldata remedy
    ) external onlySteward {
        bytes32 k = keyFor(vinOrId);
        logs[k].push(Diagnostic(code, summary, remedy, block.timestamp));
        emit DiagnosticLogged(k, code, summary, remedy);
    }

    function count(string calldata vinOrId) external view returns (uint256) {
        return logs[keyFor(vinOrId)].length;
    }

    function get(bytes32 assetKey, uint256 idx) external view returns (Diagnostic memory) {
        return logs[assetKey][idx];
    }
}
