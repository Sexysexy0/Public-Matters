// contracts/MotorAccessArc.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MotorAccessArc
 * @notice Repo-style direct monthly installment access for motorcycles (Honda Click, Suzuki Raider).
 */
contract MotorAccessArc {
    address public admin;

    struct Plan {
        string model;           // e.g., "Honda Click 125i" or "Suzuki Raider 150"
        uint256 monthlyPayment; // must be <= 3000
        uint16 termMonths;      // 24–60 months typical
        bool active;
    }

    mapping(address => Plan) public plans;

    event PlanCreated(address indexed wallet, string model, uint256 monthlyPayment, uint16 termMonths);
    event PaymentRecorded(address indexed wallet, uint256 amount);
    event PlanStatusChanged(address indexed wallet, bool active);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createPlan(address wallet, string calldata model, uint256 monthlyPayment, uint16 termMonths) external onlyAdmin {
        require(monthlyPayment <= 3000, "Monthly must be <= 3000");
        require(termMonths >= 24 && termMonths <= 60, "Invalid term");
        plans[wallet] = Plan(model, monthlyPayment, termMonths, true);
        emit PlanCreated(wallet, model, monthlyPayment, termMonths);
    }

    function recordPayment(address wallet, uint256 amount) external onlyAdmin {
        require(plans[wallet].active, "Plan inactive");
        emit PaymentRecorded(wallet, amount);
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
