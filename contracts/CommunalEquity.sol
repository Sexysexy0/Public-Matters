// contracts/CommunalEquity.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CommunalEquity
 * @notice Protocols for fair distribution of wealth, wages, and essential access.
 */
contract CommunalEquity {
    address public admin;

    struct EquityProgram {
        string name;            // e.g., "Minimum Wage Boost", "Repo-Style Housing"
        string targetGroup;     // e.g., "12k-17k earners", "Disaster-affected families"
        string method;          // e.g., "Direct transfer", "Installment credit", "Voucher"
        uint256 amountPerUnit;  // numeric value per disbursement unit
        bool active;
        uint256 createdAt;
    }

    struct Disbursement {
        uint256 programId;
        address recipient;
        uint256 amount;
        uint256 timestamp;
    }

    EquityProgram[] public programs;
    Disbursement[] public disbursements;
    mapping(uint256 => uint256) public totalDistributedByProgram;

    event ProgramRegistered(uint256 indexed programId, string name, string targetGroup, string method, uint256 amountPerUnit, bool active);
    event ProgramStatusUpdated(uint256 indexed programId, bool active);
    event DisbursementLogged(uint256 indexed programId, address indexed recipient, uint256 amount, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerProgram(
        string calldata name,
        string calldata targetGroup,
        string calldata method,
        uint256 amountPerUnit,
        bool active
    ) external onlyAdmin returns (uint256 programId) {
        programs.push(EquityProgram(name, targetGroup, method, amountPerUnit, active, block.timestamp));
        programId = programs.length - 1;
        emit ProgramRegistered(programId, name, targetGroup, method, amountPerUnit, active);
    }

    function setProgramActive(uint256 programId, bool active) external onlyAdmin {
        require(programId < programs.length, "Invalid programId");
        programs[programId].active = active;
        emit ProgramStatusUpdated(programId, active);
    }

    function logDisbursement(uint256 programId, address recipient, uint256 amount) external onlyAdmin {
        require(programId < programs.length, "Invalid programId");
        require(programs[programId].active, "Program inactive");
        disbursements.push(Disbursement(programId, recipient, amount, block.timestamp));
        totalDistributedByProgram[programId] += amount;
        emit DisbursementLogged(programId, recipient, amount, block.timestamp);
    }

    function totalPrograms() external view returns (uint256) {
        return programs.length;
    }

    function totalDisbursements() external view returns (uint256) {
        return disbursements.length;
    }

    function getProgram(uint256 id) external view returns (EquityProgram memory) {
        require(id < programs.length, "Invalid id");
        return programs[id];
    }

    function getDisbursement(uint256 id) external view returns (Disbursement memory) {
        require(id < disbursements.length, "Invalid id");
        return disbursements[id];
    }

    function getTotalDistributed(uint256 programId) external view returns (uint256) {
        require(programId < programs.length, "Invalid programId");
        return totalDistributedByProgram[programId];
    }
}
