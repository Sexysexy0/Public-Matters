// BarterTradeProtocol.sol
pragma solidity ^0.8.0;

contract BarterTradeProtocol {
    struct BarterAgreement {
        string commodityExchanged; // e.g., "Rice", "Nickel", "Coconut Oil"
        uint256 commodityQuantity;
        uint256 oilBarrelsReceived;
        uint256 expiryDate;
    }

    mapping(address => BarterAgreement) public nationAgreements;

    function initiateBarter(string memory _item, uint256 _qty, uint256 _oilQty) public {
        nationAgreements[msg.sender] = BarterAgreement(_item, _qty, _oilQty, block.timestamp + 365 days);
    }
}
