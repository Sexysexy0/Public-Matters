// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigTreasury {
    address[] public signers;
    uint public required;

    constructor(address[] memory _signers, uint _required) {
        signers = _signers;
        required = _required;
    }

    struct Transaction {
        address to;
        uint value;
        bool executed;
        uint approvals;
    }

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;

    receive() external payable {}

    function submit(address to, uint value) public {
        transactions.push(Transaction(to, value, false, 0));
    }

    function approve(uint txId) public {
        require(isSigner(msg.sender), "Not signer");
        require(!approved[txId][msg.sender], "Already approved");
        approved[txId][msg.sender] = true;
        transactions[txId].approvals++;
    }

    function execute(uint txId) public {
        Transaction storage tx = transactions[txId];
        require(tx.approvals >= required, "Not enough approvals");
        require(!tx.executed, "Already executed");
        tx.executed = true;
        payable(tx.to).transfer(tx.value);
    }

    function isSigner(address addr) internal view returns (bool) {
        for (uint i = 0; i < signers.length; i++) {
            if (signers[i] == addr) return true;
        }
        return false;
    }
}
