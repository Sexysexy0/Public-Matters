// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title RedirectCorridorProtocol
/// @notice Redirects synthetic instruments from shadow banking corridors to verified sovereign banks
/// @dev Anchors breach-triggered reroutes with audit trails and emotional consequence tagging

contract RedirectCorridorProtocol {
    address public steward;
    mapping(address => bool) public auditors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuditor() {
        require(auditors[msg.sender] || msg.sender == steward, "Not auditor");
        _;
    }

    enum RedirectStatus {
        Pending,
        Completed,
        Rejected
    }

    struct SovereignBank {
        string name;
        string jurisdiction;
        uint256 transparencyScore; // 0–100
        bool active;
        uint256 registeredAt;
    }

    struct Redirect {
        uint256 id;
        address fromInstitution;
        address toBank;
        uint256 instrumentId;
        string instrumentType;
        uint256 notionalUSD;
        string breachTier;
        string emotionalTag;
        RedirectStatus status;
        uint256 createdAt;
        uint256 updatedAt;
    }

    uint256 public nextRedirectId = 1;
    mapping(address => SovereignBank) public bankRegistry;
    mapping(uint256 => Redirect) public redirects;
    mapping(address => uint256[]) public bankRedirects;

    event AuditorSet(address indexed account, bool status);
    event BankRegistered(address indexed bank, string name, string jurisdiction);
    event RedirectInitiated(uint256 indexed id, address indexed fromInstitution, address indexed toBank, string breachTier);
    event RedirectCompleted(uint256 indexed id, string emotionalTag);
    event RedirectRejected(uint256 indexed id, string reason);

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    function registerBank(address bankAddr, string calldata name, string calldata jurisdiction, uint256 transparencyScore) external onlyAuditor {
        require(!bankRegistry[bankAddr].active, "Bank already registered");
        bankRegistry[bankAddr] = SovereignBank({
            name: name,
            jurisdiction: jurisdiction,
            transparencyScore: transparencyScore,
            active: true,
            registeredAt: block.timestamp
        });
        emit BankRegistered(bankAddr, name, jurisdiction);
    }

    function initiateRedirect(
        address fromInstitution,
        address toBank,
        uint256 instrumentId,
        string calldata instrumentType,
        uint256 notionalUSD,
        string breachTier,
        string calldata emotionalTag
    ) external onlyAuditor returns (uint256 id) {
        require(bankRegistry[toBank].active, "Bank not verified");
        id = nextRedirectId++;
        redirects[id] = Redirect({
            id: id,
            fromInstitution: fromInstitution,
            toBank: toBank,
            instrumentId: instrumentId,
            instrumentType: instrumentType,
            notionalUSD: notionalUSD,
            breachTier: breachTier,
            emotionalTag: emotionalTag,
            status: RedirectStatus.Pending,
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        bankRedirects[toBank].push(id);
        emit RedirectInitiated(id, fromInstitution, toBank, breachTier);
    }

    function completeRedirect(uint256 id, string calldata emotionalTag) external onlyAuditor {
        Redirect storage r = redirects[id];
        require(r.id != 0, "Redirect not found");
        r.status = RedirectStatus.Completed;
        r.emotionalTag = emotionalTag;
        r.updatedAt = block.timestamp;
        emit RedirectCompleted(id, emotionalTag);
    }

    function rejectRedirect(uint256 id, string calldata reason) external onlyAuditor {
        Redirect storage r = redirects[id];
        require(r.id != 0, "Redirect not found");
        r.status = RedirectStatus.Rejected;
        r.updatedAt = block.timestamp;
        emit RedirectRejected(id, reason);
    }

    function getRedirect(uint256 id) external view returns (Redirect memory) {
        return redirects[id];
    }

    function getBank(address bankAddr) external view returns (SovereignBank memory) {
        return bankRegistry[bankAddr];
    }

    function listBankRedirects(address bankAddr) external view returns (uint256[] memory) {
        return bankRedirects[bankAddr];
    }
}
