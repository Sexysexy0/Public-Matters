// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EthicsMandala
/// @notice Safeguard covenant encoding ethical burden of science
/// @dev Scientists/developers must commit to ethical covenants before using powerful tools
contract EthicsMandala {
    address public guardian;

    enum Covenant { None, TruthAboveGain, Discipline, Transparency }
    mapping(address => Covenant) public covenants;

    event CovenantSigned(address indexed scientist, Covenant covenant);
    event CovenantRevoked(address indexed scientist);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    constructor() {
        guardian = msg.sender;
    }

    /// @notice Sign an ethical covenant
    function signCovenant(Covenant c) external {
        require(c != Covenant.None, "Invalid covenant");
        covenants[msg.sender] = c;
        emit CovenantSigned(msg.sender, c);
    }

    /// @notice Guardian can revoke covenant
    function revokeCovenant(address scientist) external onlyGuardian {
        covenants[scientist] = Covenant.None;
        emit CovenantRevoked(scientist);
    }

    /// @notice Check if scientist has a specific covenant
    function hasCovenant(address scientist, Covenant c) external view returns (bool) {
        return covenants[scientist] == c;
    }
}
