// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract NuclearConflictRegistry {
    struct Conflict {
        address declarant;
        bytes32 subject;
        bytes32 disclosureHash;
        uint64 declaredAt;
        uint64 expiresAt;
        bool active;
    }

    error Unauthorized();
    error InvalidInput();
    error AlreadyExists();
    error MissingConflict();
    error AlreadyInactive();

    address public owner;
    uint256 public nextConflictId = 1;

    mapping(address => bool) public administrators;
    mapping(uint256 => Conflict) private conflicts;
    mapping(address => mapping(bytes32 => uint256)) public activeConflictId;

    event AdministratorUpdated(address indexed administrator, bool authorized);
    event ConflictDeclared(
        uint256 indexed conflictId,
        address indexed declarant,
        bytes32 indexed subject,
        bytes32 disclosureHash,
        uint64 expiresAt
    );
    event ConflictRevoked(
        uint256 indexed conflictId,
        address indexed declarant
    );
    event ConflictExpired(uint256 indexed conflictId);

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    modifier onlyAdministrator() {
        if (!administrators[msg.sender]) revert Unauthorized();
        _;
    }

    constructor() {
        owner = msg.sender;
        administrators[msg.sender] = true;
        emit AdministratorUpdated(msg.sender, true);
    }

    function setAdministrator(
        address administrator,
        bool authorized
    ) external onlyOwner {
        if (administrator == address(0)) revert InvalidInput();
        administrators[administrator] = authorized;
        emit AdministratorUpdated(administrator, authorized);
    }

    function declareConflict(
        bytes32 subject,
        bytes32 disclosureHash,
        uint64 expiresAt
    ) external returns (uint256 conflictId) {
        if (subject == bytes32(0) || disclosureHash == bytes32(0)) {
            revert InvalidInput();
        }
        if (expiresAt != 0 && expiresAt <= block.timestamp) {
            revert InvalidInput();
        }
        if (isConflicted(msg.sender, subject)) revert AlreadyExists();

        conflictId = nextConflictId++;
        conflicts[conflictId] = Conflict({
            declarant: msg.sender,
            subject: subject,
            disclosureHash: disclosureHash,
            declaredAt: uint64(block.timestamp),
            expiresAt: expiresAt,
            active: true
        });
        activeConflictId[msg.sender][subject] = conflictId;

        emit ConflictDeclared(
            conflictId,
            msg.sender,
            subject,
            disclosureHash,
            expiresAt
        );
    }

    function revokeConflict(uint256 conflictId) external {
        Conflict storage conflict = conflicts[conflictId];
        if (conflict.declarant == address(0)) revert MissingConflict();
        if (conflict.declarant != msg.sender && !administrators[msg.sender]) {
            revert Unauthorized();
        }
        if (!conflict.active) revert AlreadyInactive();

        conflict.active = false;
        if (activeConflictId[conflict.declarant][conflict.subject] == conflictId) {
            delete activeConflictId[conflict.declarant][conflict.subject];
        }

        emit ConflictRevoked(conflictId, conflict.declarant);
    }

    function expireConflict(uint256 conflictId) external {
        Conflict storage conflict = conflicts[conflictId];
        if (conflict.declarant == address(0)) revert MissingConflict();
        if (!conflict.active) revert AlreadyInactive();
        if (conflict.expiresAt == 0 || block.timestamp < conflict.expiresAt) {
            revert InvalidInput();
        }

        conflict.active = false;
        if (activeConflictId[conflict.declarant][conflict.subject] == conflictId) {
            delete activeConflictId[conflict.declarant][conflict.subject];
        }

        emit ConflictExpired(conflictId);
    }

    function isConflicted(
        address declarant,
        bytes32 subject
    ) public view returns (bool) {
        uint256 conflictId = activeConflictId[declarant][subject];
        if (conflictId == 0) return false;

        Conflict memory conflict = conflicts[conflictId];
        if (!conflict.active) return false;
        if (conflict.expiresAt != 0 && block.timestamp >= conflict.expiresAt) {
            return false;
        }
        return true;
    }

    function getConflict(
        uint256 conflictId
    ) external view returns (Conflict memory) {
        if (conflicts[conflictId].declarant == address(0)) {
            revert MissingConflict();
        }
        return conflicts[conflictId];
    }
}
