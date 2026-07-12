// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Judgment
/// @notice Accountability and evaluative safeguard contract
contract CovenantJudgment {
    address public guardian;
    uint256 public judgmentCount;

    struct Verdict {
        uint256 id;
        string subject;
        string evaluation;
        string consequence;
        bool finalized;
    }

    mapping(uint256 => Verdict) public verdicts;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event JudgmentDeclared(uint256 indexed id, string subject);
    event JudgmentFinalized(uint256 indexed id, string consequence);

    constructor() {
        guardian = msg.sender;
        judgmentCount = 0;
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

    /// @notice Mag‑declare ng judgment subject
    function declareJudgment(string calldata subject, string calldata evaluation) external onlyGuardian {
        judgmentCount++;
        verdicts[judgmentCount] = Verdict(judgmentCount, subject, evaluation, "", false);
        emit JudgmentDeclared(judgmentCount, subject);
    }

    /// @notice Mag‑finalize ng judgment at mag‑assign ng consequence
    function finalizeJudgment(uint256 id, string calldata consequence) external onlyGuardian {
        Verdict storage v = verdicts[id];
        require(!v.finalized, "Already finalized");
        v.consequence = consequence;
        v.finalized = true;
        emit JudgmentFinalized(id, consequence);
    }

    /// @notice Tingnan ang judgment details
    function viewJudgment(uint256 id) external view returns (Verdict memory) {
        return verdicts[id];
    }
}
