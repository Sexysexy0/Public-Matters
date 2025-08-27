// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract FundSanctumIntegrityProtocol {
    address public steward;

    struct Transaction {
        string item;
        uint256 amount;
        string supplier;
        string receiptHash;
        uint256 timestamp;
        bool isVerified;
    }

    struct LandPurchase {
        string location;
        uint256 price;
        string seller;
        string deedHash;
        bool isVerified;
    }

    Transaction[] public transactions;
    LandPurchase[] public landPurchases;

    event TransactionLogged(string item, uint256 amount, string supplier);
    event TransactionVerified(string item, string status);
    event LandLogged(string location, uint256 price, string seller);
    event LandVerified(string location, string status);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized audit attempt.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logTransaction(string memory item, uint256 amount, string memory supplier, string memory receiptHash) public onlySteward {
        transactions.push(Transaction({
            item: item,
            amount: amount,
            supplier: supplier,
            receiptHash: receiptHash,
            timestamp: block.timestamp,
            isVerified: false
        }));

        emit TransactionLogged(item, amount, supplier);
    }

    function verifyTransaction(uint256 index) public onlySteward {
        require(index < transactions.length, "Invalid transaction index.");
        transactions[index].isVerified = true;
        emit TransactionVerified(transactions[index].item, "Verified. Trusted source confirmed.");
    }

    function logLandPurchase(string memory location, uint256 price, string memory seller, string memory deedHash) public onlySteward {
        landPurchases.push(LandPurchase({
            location: location,
            price: price,
            seller: seller,
            deedHash: deedHash,
            isVerified: false
        }));

        emit LandLogged(location, price, seller);
    }

    function verifyLand(uint256 index) public onlySteward {
        require(index < landPurchases.length, "Invalid land index.");
        landPurchases[index].isVerified = true;
        emit LandVerified(landPurchases[index].location, "Land deed verified. Emotional APR synced.");
    }

    function auditTransaction(uint256 index) public view returns (string memory) {
        Transaction memory t = transactions[index];
        return string(abi.encodePacked(
            "Item: ", t.item,
            " | Amount: ₱", uint2str(t.amount),
            " | Supplier: ", t.supplier,
            " | Receipt Hash: ", t.receiptHash,
            " | Verified: ", t.isVerified ? "Yes" : "No"
        ));
    }

    function auditLand(uint256 index) public view returns (string memory) {
        LandPurchase memory l = landPurchases[index];
        return string(abi.encodePacked(
            "Location: ", l.location,
            " | Price: ₱", uint2str(l.price),
            " | Seller: ", l.seller,
            " | Deed Hash: ", l.deedHash,
            " | Verified: ", l.isVerified ? "Yes" : "No"
        ));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
