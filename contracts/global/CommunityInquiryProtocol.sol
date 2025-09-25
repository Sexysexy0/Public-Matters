// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract CommunityInquiryProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct InquiryCorridor {
        uint256 id;
        string citizen;
        string inquiryType; // e.g., "Housing request", "Payment option", "Location preference"
        bool overrideBlocked;
        bool inquiryHonored;
        string emotionalTag; // e.g., "Inquiry sovereignty activated"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => InquiryCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event InquiryCorridorActivated(uint256 indexed id, string citizen, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateInquiryCorridor(
        string calldata citizen,
        string calldata inquiryType,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = InquiryCorridor({
            id: id,
            citizen: citizen,
            inquiryType: inquiryType,
            overrideBlocked: true,
            inquiryHonored: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit InquiryCorridorActivated(id, citizen, emotionalTag);
    }

    function getInquiryCorridor(uint256 id) external view returns (InquiryCorridor memory) {
        return corridors[id];
    }
}
