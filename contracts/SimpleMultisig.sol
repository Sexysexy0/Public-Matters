// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SimpleMultisig
/// @notice Lightweight multisig for shared custody and admin actions
contract SimpleMultisig {
    uint public threshold;
    address[] public owners;
    mapping(address => bool) public isOwner;

    struct Tx { address to; uint value; bytes data; bool executed; uint approvals; }
    Tx[] public txs;
    mapping(uint => mapping(address => bool)) public approved;

    event TxSubmitted(uint indexed txId, address indexed proposer, address to, uint value);
    event TxApproved(uint indexed txId, address indexed approver);
    event TxExecuted(uint indexed txId, address indexed executor);

    constructor(address[] memory _owners, uint _threshold) {
        require(_owners.length > 0, "owners required");
        require(_threshold > 0 && _threshold <= _owners.length, "invalid threshold");
        owners = _owners;
        threshold = _threshold;
        for (uint i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "zero owner");
            isOwner[_owners[i]] = true;
        }
    }

    modifier onlyOwner() { require(isOwner[msg.sender], "not owner"); _; }

    function submit(address to, uint value, bytes calldata data) external onlyOwner returns (uint) {
        txs.push(Tx(to, value, data, false, 0));
        uint txId = txs.length - 1;
        emit TxSubmitted(txId, msg.sender, to, value);
        return txId;
    }

    function approve(uint txId) external onlyOwner {
        require(txId < txs.length, "invalid tx");
        require(!approved[txId][msg.sender], "already approved");
        approved[txId][msg.sender] = true;
        txs[txId].approvals++;
        emit TxApproved(txId, msg.sender);
    }

    function execute(uint txId) external {
        require(txId < txs.length, "invalid tx");
        Tx storage t = txs[txId];
        require(!t.executed, "already executed");
        require(t.approvals >= threshold, "insufficient approvals");
        t.executed = true;
        (bool ok, ) = t.to.call{value: t.value}(t.data);
        require(ok, "call failed");
        emit TxExecuted(txId, msg.sender);
    }

    receive() external payable {}
}
