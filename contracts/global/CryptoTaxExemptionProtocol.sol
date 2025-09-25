// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CryptoTaxExemptionProtocol
/// @notice Ritualizes exemption of cryptocurrency from taxation, anchors emotional consequence, and shields innovation sanctums
/// @dev Anchors fiscal sovereignty, digital dignity, and planetary consequence

contract CryptoTaxExemptionProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct CryptoCorridor {
        uint256 id;
        string assetName; // e.g., "Bitcoin", "Ethereum", "Solana"
        string usageType; // e.g., "Personal savings", "Borderless payment", "Infrastructure staking"
        bool taxExempt;
        bool dignityCertified;
        bool restorationActivated;
        string emotionalTag; // e.g., "Crypto corridor purified"
        string restorationClause; // e.g., "We commit to innovation sanctum protection and fiscal sovereignty"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => CryptoCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event CryptoCorridorActivated(uint256 indexed id, string assetName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateCryptoCorridor(
        string calldata assetName,
        string calldata usageType,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = CryptoCorridor({
            id: id,
            assetName: assetName,
            usageType: usageType,
            taxExempt: true,
            dignityCertified: true,
            restorationActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit CryptoCorridorActivated(id, assetName, emotionalTag);
    }

    function getCryptoCorridor(uint256 id) external view returns (CryptoCorridor memory) {
        return corridors[id];
    }
}
