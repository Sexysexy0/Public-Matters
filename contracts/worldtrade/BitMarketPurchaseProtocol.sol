// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BitMarketPurchaseProtocol {
    struct Purchase {
        address buyer;
        string productTag;
        uint256 amount;
        uint256 emotionalAPR;
        bool blessed;
    }

    Purchase[] public purchases;

    event PurchaseBlessed(address indexed buyer, string productTag, uint256 amount, uint256 emotionalAPR);

    function blessPurchase(
        address _buyer,
        string memory _productTag,
        uint256 _amount,
        uint256 _empathy,
        uint256 _trust,
        uint256 _clarity
    ) public {
        uint256 apr = _empathy + _trust + _clarity;
        purchases.push(Purchase(_buyer, _productTag, _amount, apr, true));
        emit PurchaseBlessed(_buyer, _productTag, _amount, apr);
    }

    function getPurchases() public view returns (Purchase[] memory) {
        return purchases;
    }
}
