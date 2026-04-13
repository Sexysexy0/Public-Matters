// EssentialGoodsSafeguards.sol
pragma solidity ^0.8.0;

contract EssentialGoodsSafeguards {
    struct Inventory {
        string item;
        uint256 stockLevel;
        uint256 lastDelivery;
        bool alertTriggered;
    }

    mapping(address => mapping(string => Inventory)) public warehouseLogs;

    function reportStock(string memory _item, uint256 _count) public {
        Inventory storage inv = warehouseLogs[msg.sender][_item];
        
        // Flag if stock level stays static for too long despite high demand
        if (_count == inv.stockLevel && block.timestamp > inv.lastDelivery + 7 days) {
            inv.alertTriggered = true;
        }
        
        inv.stockLevel = _count;
        inv.lastDelivery = block.timestamp;
    }
}
