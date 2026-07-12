// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Tribunal
/// @notice Judicial oversight contract for resolving disputes in covenant governance
contract CovenantTribunal {
    address public guardian;
    mapping(uint256 => Ruling) public rulings;
    uint256 public rulingCount;

    struct Ruling {
        uint256 id;
        address complainant;
        address respondent;
        string issue;
        bool verdict; // true = complainant wins, false = respondent wins
        bool resolved;
    }

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event CaseFiled(uint256 indexed id, address complainant, address respondent, string issue);
    event VerdictIssued(uint256 indexed id, bool verdict);

    constructor() {
        guardian = msg.sender;
        rulingCount = 0;
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

    /// @notice Mag‑file ng kaso sa tribunal
    function fileCase(address respondent, string calldata issue) external {
        rulingCount++;
        rulings[rulingCount] = Ruling(rulingCount, msg.sender, respondent, issue, false, false);
        emit CaseFiled(rulingCount, msg.sender, respondent, issue);
    }

    /// @notice Mag‑issue ng verdict (guardian only)
    function issueVerdict(uint256 id, bool verdict) external onlyGuardian {
        Ruling storage r = rulings[id];
        require(!r.resolved, "Already resolved");
        r.verdict = verdict;
        r.resolved = true;
        emit VerdictIssued(id, verdict);
    }

    /// @notice Tingnan ang ruling details
    function viewRuling(uint256 id) external view returns (Ruling memory) {
        return rulings[id];
    }
}
