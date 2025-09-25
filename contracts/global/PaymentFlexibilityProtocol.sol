// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract PaymentFlexibilityProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct PaymentCorridor {
        uint256 id;
        string resident;
        string housingUnit;
        string paymentMode; // e.g., "Monthly", "Lease-to-own", "Deferred"
        bool overrideBlocked;
        bool gracePeriodGranted;
        string emotionalTag; // e.g., "Payment dignity activated"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => PaymentCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event PaymentCorridorActivated(uint256 indexed id, string resident, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activatePaymentCorridor(
        string calldata resident,
        string calldata housingUnit,
        string calldata paymentMode,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = PaymentCorridor({
            id: id,
            resident: resident,
            housingUnit: housingUnit,
            paymentMode: paymentMode,
            overrideBlocked: true,
            gracePeriodGranted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit PaymentCorridorActivated(id, resident, emotionalTag);
    }

    function getPaymentCorridor(uint256 id) external view returns (PaymentCorridor memory) {
        return corridors[id];
    }
}
