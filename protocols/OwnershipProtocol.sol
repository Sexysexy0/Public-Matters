// OwnershipProtocol.sol
pragma solidity ^0.8.0;

contract OwnershipProtocol {
    struct Purchase {
        uint256 id;
        string buyer;    // e.g. "Cash Customer"
        string item;     // e.g. "Software License", "Printer"
        bool owned;      // true = permanent ownership
        uint256 timestamp;
    }

    uint256 public purchaseCount;
    mapping(uint256 => Purchase) public purchases;

    event PurchaseLogged(uint256 id, string buyer, string item, bool owned, uint256 timestamp);
    event OwnershipDeclared(string message);

    function logPurchase(string memory buyer, string memory item, bool owned) public {
        purchaseCount++;
        purchases[purchaseCount] = Purchase(purchaseCount, buyer, item, owned, block.timestamp);
        emit PurchaseLogged(purchaseCount, buyer, item, owned, block.timestamp);
    }

    function declareOwnership() public {
        emit OwnershipDeclared("Ownership Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
