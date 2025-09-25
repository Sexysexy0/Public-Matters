// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ExportCorridorSanctifier
/// @notice Registers and sanctifies cannabis export corridors with treaty-grade dignity
/// @dev Anchors emotional consequence and trade ethics

contract ExportCorridorSanctifier {
    address public steward;
    mapping(address => bool) public tradeAuditors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuditor() {
        require(tradeAuditors[msg.sender] || msg.sender == steward, "Not auditor");
        _;
    }

    struct ExportCorridor {
        uint256 id;
        string origin; // e.g., "USA"
        string destination; // e.g., "EU"
        string product; // e.g., "Medical Cannabis"
        string treatyTag;
        string emotionalTag;
        uint256 createdAt;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => ExportCorridor) public corridors;

    event AuditorSet(address indexed account, bool status);
    event CorridorSanctified(uint256 indexed id, string origin, string destination, string emotionalTag);

    constructor() {
        steward = msg.sender;
        tradeAuditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        tradeAuditors[account] = status;
        emit AuditorSet(account, status);
    }

    function sanctifyCorridor(string calldata origin, string calldata destination, string calldata product, string calldata treatyTag, string calldata emotionalTag) external onlyAuditor returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = ExportCorridor({
            id: id,
            origin: origin,
            destination: destination,
            product: product,
            treatyTag: treatyTag,
            emotionalTag: emotionalTag,
            createdAt: block.timestamp
        });
        emit CorridorSanctified(id, origin, destination, emotionalTag);
    }

    function getCorridor(uint256 id) external view returns (ExportCorridor memory) {
        return corridors[id];
    }
}
