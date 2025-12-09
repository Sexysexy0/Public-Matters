// contracts/EssentialAssetArc.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EssentialAssetArc
 * @notice Direct monthly installment access for family essentials (appliances, laptops, phones).
 */
contract EssentialAssetArc {
    address public admin;

    enum AssetType { Appliance, Laptop, Phone, FamilyEssential }

    struct Plan {
        AssetType assetType;
        string itemName;
        uint256 monthlyPayment; // target <= 3000
        uint16 termMonths;      // flexible 12–36 months
        uint256 totalPaid;
        bool active;
    }

    mapping(address => Plan) public plans;

    event PlanCreated(address indexed wallet, AssetType assetType, string itemName, uint256 monthlyPayment, uint16 termMonths);
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
        string calldata itemName,
        uint256 monthlyPayment,
        uint16 termMonths
    ) external onlyAdmin {
        require(monthlyPayment <= 3000, "Monthly must be <= 3000");
        require(termMonths > 0, "Invalid term");
        plans[wallet] = Plan(assetType, itemName, monthlyPayment, termMonths, 0, true);
        emit PlanCreated(wallet, assetType, itemName, monthlyPayment, termMonths);
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
