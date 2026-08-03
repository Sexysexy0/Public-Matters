// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TransparentLaborPayrollRegistry
 * @dev Verifiable Worker Attendance, Transparent Deductions, and Escrowed Payroll Disbursement
 */
contract TransparentLaborPayrollRegistry {
    address public rootAdmin;

    struct Worker {
        string workerId;
        uint256 dailyRate;
        address wallet;
        bool isActive;
    }

    struct PayrollRecord {
        uint256 daysWorked;
        uint256 grossPay;
        uint256 statutoryDeductions;
        uint256 netPay;
        bool isDisbursed;
    }

    mapping(address => Worker) public workers;
    mapping(address => mapping(uint256 => PayrollRecord)) public workerPayrollHistory; // worker => cycleId => record

    event WorkerRegistered(address indexed workerWallet, string workerId, uint256 dailyRate);
    event PayrollProcessed(address indexed workerWallet, uint256 indexed cycleId, uint256 netPay);
    event PayrollDisbursed(address indexed workerWallet, uint256 indexed cycleId, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == rootAdmin, "TLPR: Only Root Admin authorized");
        _;
    }

    constructor() payable {
        rootAdmin = msg.sender;
    }

    receive() external payable {}

    function registerWorker(
        address _workerWallet,
        string memory _workerId,
        uint256 _dailyRate
    ) external onlyAdmin {
        require(_workerWallet != address(0), "TLPR: Invalid worker address");
        require(_dailyRate > 0, "TLPR: Daily rate must be greater than zero");

        workers[_workerWallet] = Worker({
            workerId: _workerId,
            dailyRate: _dailyRate,
            wallet: _workerWallet,
            isActive: true
        });

        emit WorkerRegistered(_workerWallet, _workerId, _dailyRate);
    }

    function processPayroll(
        address _workerWallet,
        uint256 _cycleId,
        uint256 _daysWorked,
        uint256 _statutoryDeductions
    ) external onlyAdmin {
        Worker memory worker = workers[_workerWallet];
        require(worker.isActive, "TLPR: Worker is not active");
        require(_daysWorked > 0, "TLPR: Days worked must be greater than zero");

        uint256 grossPay = worker.dailyRate * _daysWorked;
        require(grossPay > _statutoryDeductions, "TLPR: Deductions exceed gross pay");
        uint256 netPay = grossPay - _statutoryDeductions;

        workerPayrollHistory[_workerWallet][_cycleId] = PayrollRecord({
            daysWorked: _daysWorked,
            grossPay: grossPay,
            statutoryDeductions: _statutoryDeductions,
            netPay: netPay,
            isDisbursed: false
        });

        emit PayrollProcessed(_workerWallet, _cycleId, netPay);
    }

    function disbursePayroll(address _workerWallet, uint256 _cycleId) external onlyAdmin {
        PayrollRecord storage record = workerPayrollHistory[_workerWallet][_cycleId];
        require(!record.isDisbursed, "TLPR: Payroll already disbursed");
        require(record.netPay > 0, "TLPR: Invalid net pay");
        require(address(this).balance >= record.netPay, "TLPR: Insufficient contract balance");

        record.isDisbursed = true;

        (bool success, ) = payable(_workerWallet).call{value: record.netPay}("");
        require(success, "TLPR: Disbursement transfer failed");

        emit PayrollDisbursed(_workerWallet, _cycleId, record.netPay);
    }
}
