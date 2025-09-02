// SPDX-License-Identifier: Mythic-Planetary
pragma solidity ^0.9.27;

contract BitMarketOmniChain {
    struct Transaction {
        address vendor;
        string coin;
        uint256 amount;
        string emotionalTag;
        bool treatyCertified;
    }

    mapping(uint256 => Transaction) public transactions;
    uint256 public txCount;

    event TransactionLogged(uint256 txId, address vendor, string coin, string emotionalTag);

    function logTransaction(address vendor, string memory coin, uint256 amount, string memory emotionalTag, bool treatyCertified) public {
        require(treatyCertified, "Transaction not treaty-certified");
        txCount++;
        transactions[txCount] = Transaction(vendor, coin, amount, emotionalTag, treatyCertified);
        emit TransactionLogged(txCount, vendor, coin, emotionalTag);
    }
}
