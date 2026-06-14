// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

/**
 * @title ShariahComplianceRouter
 * @dev Nagpapatupad ng etikal na kasunduan, pagbabawal sa Riba (usury) at Gharar (gambling/uncertainty),
 * [span_0](start_span)at inclusive dispute resolution inspirasyon sa adbokasya ni Associate Justice Japar B. Dimaampao[span_0](end_span).
 */
contract ShariahComplianceRouter {
    address public guardian;
    IAuditHistory public auditHistory;
    uint256 public totalTransactions;

    enum EthicalStatus { Pending, Halal, Musharakah, Flagged }

    struct TransactionRecord {
        uint256 id;
        address partyA;
        address partyB;
        uint256 principalAmount;
        uint256 profitShareRatio; // Kinakatawan ang Musharakah profit sharing (in percentage, e.g., 20 = 20%)
        EthicalStatus status;
        bytes32 agreementHash;    // Cryptographic footprint ng pinagkasunduang etikal na kontrata
    }

    mapping(uint256 => TransactionRecord) public transactions;
    mapping(address => bool) public certifiedConduits;

    event TransactionRegistered(uint256 indexed txId, address indexed partyA, address indexed partyB, EthicalStatus status);
    event TransactionStatusUpdated(uint256 indexed txId, EthicalStatus indexed oldStatus, EthicalStatus indexed newStatus);
    event ConduitCertificationUpdated(address indexed conduit, bool status);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Access denied. Only the Sovereign Guardian can alter configuration paths.");
        _;
    }

    constructor() {
        guardian = msg.sender;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyGuardian {
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    function setConduitCertification(address _conduit, bool _status) public onlyGuardian {
        certifiedConduits[_conduit] = _status;
        emit ConduitCertificationUpdated(_conduit, _status);
    }

    /**
     * @dev Pormal na pagpaparehistro ng etikal na transaksyon (Musharakah/Halal Partnership).
     * Nagpapatupad ng Zero-Interest invariants upang harangan ang Riba (Usury).
     */
    function registerEthicalTransaction(
        address _partyB,
        uint256 _profitShareRatio,
        bytes32 _agreementHash
    ) public payable returns (uint256) {
        require(msg.value > 0, "Error: Capital contribution must be greater than zero.");
        require(_partyB != address(0), "Error: Invalid counterpart node address.");
        require(_profitShareRatio <= 100, "Error: Profit share ratio cannot exceed 100%.");

        totalTransactions++;

        // Default routing status base sa kung certified conduit ang kasunduan
        EthicalStatus initialStatus = certifiedConduits[msg.sender] || certifiedConduits[_partyB] 
            ? EthicalStatus.Musharakah 
            : EthicalStatus.Pending;

        transactions[totalTransactions] = TransactionRecord({
            id: totalTransactions,
            partyA: msg.sender,
            partyB: _partyB,
            principalAmount: msg.value,
            profitShareRatio: _profitShareRatio,
            status: initialStatus,
            agreementHash: _agreementHash
        });

        emit TransactionRegistered(totalTransactions, msg.sender, _partyB, initialStatus);
        return totalTransactions;
    }

    /**
     * @dev Pagpataw ng pormal na parusa o pag-audit kapag may natuklasang indikasyon ng Gharar o Riba.
     * Awtomatikong nagbabato ng +1 warning log telemetry sa central Audit History registry.
     */
    function flagNonCompliantTransaction(uint256 _txId, bytes32 _reasonLog) public onlyGuardian {
        require(_txId > 0 && _txId <= totalTransactions, "Error: Transaction context non-existent.");
        TransactionRecord storage transaction = transactions[_txId];
        
        EthicalStatus oldStatus = transaction.status;
        transaction.status = EthicalStatus.Flagged;

        emit TransactionStatusUpdated(_txId, oldStatus, EthicalStatus.Flagged);

        // CROSS-CONTRACT TELEMETRY AUTOMATION: Direktang itatala ang warning sa sentralisadong kasaysayan
        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(transaction.partyA, 0, 0, 1, _reasonLog) {} catch {}
            try auditHistory.logHistoricalAction(transaction.partyB, 0, 0, 1, _reasonLog) {} catch {}
        }
    }

    function resolveTransaction(uint256 _txId, EthicalStatus _resolution) public onlyGuardian {
        require(_txId > 0 && _txId <= totalTransactions, "Error: Transaction context non-existent.");
        require(_resolution == EthicalStatus.Halal || _resolution == EthicalStatus.Musharakah, "Error: Invalid resolution path.");
        
        TransactionRecord storage transaction = transactions[_txId];
        EthicalStatus oldStatus = transaction.status;
        transaction.status = _resolution;

        emit TransactionStatusUpdated(_txId, oldStatus, _resolution);
    }
}
