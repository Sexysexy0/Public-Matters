// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title VapeManufacturingApprovalProtocol
/// @notice Approves vape manufacturers based on safety, transparency, and treaty-grade dignity certification
/// @dev Anchors emotional consequence tagging and civic trust broadcasting

contract VapeManufacturingApprovalProtocol {
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

    enum ApprovalStatus {
        Proposed,
        Approved,
        Rejected,
        BreachFlagged
    }

    struct Manufacturer {
        uint256 id;
        address account;
        string name;
        string jurisdiction;
        string brand;
        string composition;
        ApprovalStatus status;
        string breachTier;
        string emotionalTag;
        uint256 createdAt;
        uint256 updatedAt;
    }

    uint256 public nextManufacturerId = 1;
    mapping(uint256 => Manufacturer) public registry;
    mapping(address => uint256[]) public manufacturerIds;

    event AuditorSet(address indexed account, bool status);
    event ManufacturerFiled(uint256 indexed id, address indexed account, string brand);
    event ManufacturingApproved(uint256 indexed id, string emotionalTag);

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    function fileManufacturer(
        address account,
        string calldata name,
        string calldata jurisdiction,
        string calldata brand,
        string calldata composition
    ) external onlyAuditor returns (uint256 id) {
        id = nextManufacturerId++;
        registry[id] = Manufacturer({
            id: id,
            account: account,
            name: name,
            jurisdiction: jurisdiction,
            brand: brand,
            composition: composition,
            status: ApprovalStatus.Proposed,
            breachTier: "",
            emotionalTag: "",
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        manufacturerIds[account].push(id);
        emit ManufacturerFiled(id, account, brand);
    }

    function approveManufacturer(uint256 id, string calldata emotionalTag) external onlyAuditor {
        Manufacturer storage m = registry[id];
        require(m.id != 0, "Manufacturer not found");
        m.status = ApprovalStatus.Approved;
        m.emotionalTag = emotionalTag;
        m.updatedAt = block.timestamp;
        emit ManufacturingApproved(id, emotionalTag);
    }

    function getManufacturer(uint256 id) external view returns (Manufacturer memory) {
        return registry[id];
    }

    function listManufacturerIds(address account) external view returns (uint256[] memory) {
        return manufacturerIds[account];
    }
}
