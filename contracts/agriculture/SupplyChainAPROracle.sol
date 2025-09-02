// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SupplyChainAPROracle
/// @dev Ritualizes supply chain telemetry, emotional APR scoring, and damay clause activation

contract SupplyChainAPROracle {
    address public steward;
    struct SupplyItem {
        uint256 quantity;
        string emotionalAPR;
        bool damayTriggered;
        uint256 timestamp;
    }

    mapping(bytes32 => SupplyItem) public supplyLog;

    event SupplyLogged(bytes32 indexed itemId, uint256 quantity, string apr, bool damay);
    event DamayActivated(bytes32 indexed itemId, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logSupply(bytes32 itemId, uint256 quantity, string memory apr) public onlySteward {
        bool triggerDamay = (quantity == 0 || keccak256(bytes(apr)) == keccak256(bytes("Grief")));
        supplyLog[itemId] = SupplyItem(quantity, apr, triggerDamay, block.timestamp);
        emit SupplyLogged(itemId, quantity, apr, triggerDamay);

        if (triggerDamay) {
            emit DamayActivated(itemId, "Zero quantity or grief APR detected");
        }
    }

    function getSupplyStatus(bytes32 itemId) public view returns (uint256, string memory, bool, uint256) {
        SupplyItem memory item = supplyLog[itemId];
        return (item.quantity, item.emotionalAPR, item.damayTriggered, item.timestamp);
    }
}
