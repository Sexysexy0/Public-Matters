// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransparencyLedger {
    struct Transaction {
        address recipient;
        uint256 amount;
        string purpose;
        uint256 timestamp;
        bool audited;
    }

    mapping(uint256 => Transaction) public transactions;
    uint256 public txCount;
    address public immutable independentAuditor;

    event FundsDisbursed(uint256 indexed txId, address recipient, uint256 amount, string purpose);
    event AuditApproved(uint256 indexed txId);

    modifier onlyAuditor() {
        require(msg.sender == independentAuditor, "Unauthorized: Auditor only");
        _;
    }

    constructor(address _auditor) {
        independentAuditor = _auditor;
    }

    function disburseFunds(address _recipient, uint256 _amount, string calldata _purpose) external payable {
        require(msg.value == _amount, "Amount mismatch");
        txCount++;
        transactions[txCount] = Transaction({
            recipient: _recipient,
            amount: _amount,
            purpose: _purpose,
            timestamp: block.timestamp,
            audited: false
        });

        (bool success, ) = payable(_recipient).call{value: _amount}("");
        require(success, "Transfer failed");
        
        emit FundsDisbursed(txCount, _recipient, _amount, _purpose);
    }

    function verifyAudit(uint256 _txId) external onlyAuditor {
        transactions[_txId].audited = true;
        emit AuditApproved(_txId);
    }
}
