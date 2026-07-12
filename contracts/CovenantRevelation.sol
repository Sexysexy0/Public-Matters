// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Revelation
/// @notice Disclosure and unveiling safeguard contract
contract CovenantRevelation {
    address public guardian;
    uint256 public revelationCount;

    struct Revelation {
        uint256 id;
        string subject;
        string hiddenTruth;
        string disclosure;
        bool unveiled;
    }

    mapping(uint256 => Revelation) public revelations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RevelationDeclared(uint256 indexed id, string subject, string hiddenTruth);
    event RevelationUnveiled(uint256 indexed id, string disclosure);

    constructor() {
        guardian = msg.sender;
        revelationCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑declare ng hidden truth subject
    function declareRevelation(string calldata subject, string calldata hiddenTruth) external onlyGuardian {
        revelationCount++;
        revelations[revelationCount] = Revelation(revelationCount, subject, hiddenTruth, "", false);
        emit RevelationDeclared(revelationCount, subject, hiddenTruth);
    }

    /// @notice Mag‑unveil ng revelation at mag‑assign ng disclosure
    function unveilRevelation(uint256 id, string calldata disclosure) external onlyGuardian {
        Revelation storage r = revelations[id];
        require(!r.unveiled, "Already unveiled");
        r.disclosure = disclosure;
        r.unveiled = true;
        emit RevelationUnveiled(id, disclosure);
    }

    /// @notice Tingnan ang revelation details
    function viewRevelation(uint256 id) external view returns (Revelation memory) {
        return revelations[id];
    }
}
