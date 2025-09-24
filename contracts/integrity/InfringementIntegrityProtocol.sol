// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title InfringementIntegrityProtocol
/// @notice On-chain registry for copyright/infringement cases, evidence hashes, takedown status, and counter-notices
/// @dev Designed to pair with ChannelAuthenticityProtocol for official link verification

interface IChannelAuthenticity {
    function isOfficialUrlOwner(string calldata url, string calldata name) external view returns (bool);
    function verifyLinkFingerprint(string calldata name, string calldata url, bytes32 fingerprint) external view returns (bool);
}

contract InfringementIntegrityProtocol {
    // -------- Roles --------
    address public owner;
    mapping(address => bool) public stewards;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlySteward() {
        require(stewards[msg.sender] || msg.sender == owner, "Not steward");
        _;
    }

    // -------- Types --------
    enum CaseStatus {
        Open,           // reported, under review
        TakedownSent,   // DMCA/takedown notice dispatched
        CounterNotice,  // alleged infringer responded
        Resolved,       // fixed: removed, licensed, or invalid claim
        Escalated       // legal escalation (platform dispute/court)
    }

    struct Party {
        string name;          // claimant or respondent name
        string contact;       // email or public contact ref
    }

    struct Evidence {
        bytes32 hash;         // keccak256(file/content)
        string uri;           // IPFS/Arweave/URL pointer
        string note;          // short description (e.g., "original upload watermark", "timestamp logs")
        uint256 addedAt;
    }

    struct CaseFile {
        uint256 id;
        Party claimant;
        Party respondent;
        string originalUrl;       // official/original content URL
        string infringingUrl;     // alleged copy URL
        bytes32 originalFingerprint; // fingerprint proof (watermark/public key)
        CaseStatus status;
        string notes;             // free-form notes (platform ticket, case refs)
        uint256 createdAt;
        uint256 updatedAt;
    }

    // -------- Storage --------
    IChannelAuthenticity public cap; // ChannelAuthenticityProtocol address
    uint256 public nextId = 1;
    mapping(uint256 => CaseFile) public cases;
    mapping(uint256 => Evidence[]) public caseEvidence;

    // -------- Events --------
    event StewardSet(address indexed account, bool status);
    event CaseOpened(uint256 indexed caseId, string originalUrl, string infringingUrl);
    event EvidenceAdded(uint256 indexed caseId, bytes32 hash, string uri);
    event StatusUpdated(uint256 indexed caseId, CaseStatus status, string note);
    event CaseResolved(uint256 indexed caseId, string resolution);

    // -------- Constructor --------
    constructor(address capAddress) {
        owner = msg.sender;
        stewards[msg.sender] = true;
        cap = IChannelAuthenticity(capAddress);
        emit StewardSet(msg.sender, true);
    }

    // -------- Stewardship --------
    function setSteward(address account, bool status) external onlyOwner {
        stewards[account] = status;
        emit StewardSet(account, status);
    }

    function setCAP(address capAddress) external onlyOwner {
        cap = IChannelAuthenticity(capAddress);
    }

    // -------- Case Management --------
    function openCase(
        string calldata claimantName,
        string calldata claimantContact,
        string calldata respondentName,
        string calldata respondentContact,
        string calldata originalChannelName,
        string calldata originalUrl,
        bytes32 originalFingerprint,
        string calldata infringingUrl,
        string calldata note
    ) external onlySteward returns (uint256 caseId) {
        // Verify original ownership via ChannelAuthenticityProtocol
        require(cap.isOfficialUrlOwner(originalUrl, originalChannelName), "Original URL not owned by channel");
        require(cap.verifyLinkFingerprint(originalChannelName, originalUrl, originalFingerprint), "Fingerprint mismatch");

        caseId = nextId++;
        cases[caseId] = CaseFile({
            id: caseId,
            claimant: Party({name: claimantName, contact: claimantContact}),
            respondent: Party({name: respondentName, contact: respondentContact}),
            originalUrl: originalUrl,
            infringingUrl: infringingUrl,
            originalFingerprint: originalFingerprint,
            status: CaseStatus.Open,
            notes: note,
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });

        emit CaseOpened(caseId, originalUrl, infringingUrl);
    }

    function addEvidence(
        uint256 caseId,
        bytes32 hash,
        string calldata uri,
        string calldata note
    ) external onlySteward {
        require(cases[caseId].id != 0, "Unknown case");
        caseEvidence[caseId].push(Evidence({
            hash: hash,
            uri: uri,
            note: note,
            addedAt: block.timestamp
        }));
        emit EvidenceAdded(caseId, hash, uri);
    }

    function updateStatus(
        uint256 caseId,
        CaseStatus status,
        string calldata note
    ) external onlySteward {
        require(cases[caseId].id != 0, "Unknown case");
        cases[caseId].status = status;
        cases[caseId].updatedAt = block.timestamp;
        if (status == CaseStatus.Resolved) {
            emit CaseResolved(caseId, note);
        } else {
            emit StatusUpdated(caseId, status, note);
        }
    }

    // -------- Views --------
    function getCase(uint256 caseId) external view returns (CaseFile memory cf, Evidence[] memory ev) {
        cf = cases[caseId];
        ev = caseEvidence[caseId];
    }
}
