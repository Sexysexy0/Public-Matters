// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CryptoPensionActivationProtocol
/// @notice Ritualizes crypto inclusion in pension plans with override immunity and dignity logic
/// @dev Strips red tape, activates liquidity flexibility, and anchors emotional consequence

contract CryptoPensionActivationProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyValidator() {
        require(validators[msg.sender] || msg.sender == steward, "Not validator");
        _;
    }

    struct PensionCorridor {
        uint256 id;
        string assetType; // e.g., "Bitcoin", "Ethereum", "Stablecoin"
        string workerGroup; // e.g., "Hospitality", "Tech", "Public sector"
        bool redTapeStripped;
        bool regulatoryUncertaintyNeutralized;
        bool liquidityFlexActivated;
        string emotionalTag; // e.g., "Retirement sovereignty activated"
        string restorationClause; // e.g., "We commit to dignity-first crypto pensions and unconditional liquidity access"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => PensionCorridor) public corridors;

    event ValidatorSet(address indexed account, bool status);
    event PensionCorridorActivated(uint256 indexed id, string assetType, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activatePensionCorridor(
        string calldata assetType,
        string calldata workerGroup,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = PensionCorridor({
            id: id,
            assetType: assetType,
            workerGroup: workerGroup,
            redTapeStripped: true,
            regulatoryUncertaintyNeutralized: true,
            liquidityFlexActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit PensionCorridorActivated(id, assetType, emotionalTag);
    }

    function getPensionCorridor(uint256 id) external view returns (PensionCorridor memory) {
        return corridors[id];
    }
}
