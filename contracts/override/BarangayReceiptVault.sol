// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract BarangayReceiptVault {
    address public steward;

    struct Receipt {
        string item;
        uint256 amount;
        string supplier;
        string receiptHash;
        uint256 timestamp;
        bool isVerified;
    }

    Receipt[] public receipts;

    event ReceiptLogged(string item, uint256 amount, string supplier);
    event ReceiptVerified(string item, string status);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized vault access.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logReceipt(string memory item, uint256 amount, string memory supplier, string memory receiptHash) public onlySteward {
        receipts.push(Receipt({
            item: item,
            amount: amount,
            supplier: supplier,
            receiptHash: receiptHash,
            timestamp: block.timestamp,
            isVerified: false
        }));

        emit ReceiptLogged(item, amount, supplier);
    }

    function verifyReceipt(uint256 index) public onlySteward {
        require(index < receipts.length, "Invalid receipt index.");
        receipts[index].isVerified = true;
        emit ReceiptVerified(receipts[index].item, "Verified. Trusted source confirmed.");
    }

    function auditReceipt(uint256 index) public view returns (string memory) {
        Receipt memory r = receipts[index];
        return string(abi.encodePacked(
            "Item: ", r.item,
            " | Amount: ₱", uint2str(r.amount),
            " | Supplier: ", r.supplier,
            " | Receipt Hash: ", r.receiptHash,
            " | Verified: ", r.isVerified ? "Yes" : "No"
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
