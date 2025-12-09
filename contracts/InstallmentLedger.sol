// contracts/InstallmentLedger.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title InstallmentLedger
 * @notice Track low monthly payments (2,500–4,000) for housing and essential assets (e.g., motorcycles).
 */
contract InstallmentLedger {
    enum AssetType { Housing, Motorcycle, Other }

    struct Plan {
        AssetType assetType;
        uint256 monthlyPayment;   // must be 2500–4000
        uint16 termMonths;        // e.g., 120–360 for housing; shorter for motorcycles
        uint256 totalPaid;
        bool active;
    }

    mapping(address => Plan) public plans;

    address public admin;

    event PlanCreated(address indexed wallet, AssetType assetType, uint256 monthlyPayment, uint16 termMonths);
    event PaymentRecorded(address indexed wallet, uint256 amount, uint256 totalPaid);
    event PlanStatusChanged(address indexed wallet, bool active);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createPlan(
        address wallet,
        AssetType assetType,
        uint256 monthlyPayment,
        uint16 termMonths
    ) external onlyAdmin {
        require(monthlyPayment >= 2500 && monthlyPayment <= 4000, "Monthly must be 2500–4000");
        require(termMonths > 0, "Invalid term");
        plans[wallet] = Plan(assetType, monthlyPayment, termMonths, 0, true);
        emit PlanCreated(wallet, assetType, monthlyPayment, termMonths);
    }

    function recordPayment(address wallet, uint256 amount) external onlyAdmin {
        require(plans[wallet].active, "Plan inactive");
        require(amount > 0, "Invalid amount");
        plans[wallet].totalPaid += amount;
        emit PaymentRecorded(wallet, amount, plans[wallet].totalPaid);
    }

    function setPlanActive(address wallet, bool active) external onlyAdmin {
        require(plans[wallet].termMonths > 0, "No plan");
        plans[wallet].active = active;
        emit PlanStatusChanged(wallet, active);
    }

    function getPlan(address wallet) external view returns (Plan memory) {
        require(plans[wallet].termMonths > 0, "No plan");
        return plans[wallet];
    }
}
