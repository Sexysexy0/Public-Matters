// contracts/EssentialAssetExtended.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EssentialAssetExtended
 * @notice Direct monthly installment access for appliances, laptops, phones, and family essentials.
 */
contract EssentialAssetExtended {
    address public admin;

    enum AssetType { Appliance, Laptop, Phone, FamilyEssential }

    struct Plan {
        AssetType assetType;
        string itemName;
        uint256 monthlyPayment;
        uint16 termMonths;
        uint256 totalPaid;
        bool active;
    }

    mapping(address => Plan) public plans;

    event PlanCreated(address indexed wallet, AssetType assetType, string itemName, uint256 monthlyPayment, uint16 termMonths);
    event PaymentLogged(address indexed wallet, uint256 amount, uint256 totalPaid);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createPlan(address wallet, AssetType assetType, string calldata itemName, uint256 monthlyPayment, uint16 termMonths) external onlyAdmin {
        require(monthlyPayment <= 3000, "Monthly must be <= 3000");
        plans[wallet] = Plan(assetType, itemName, monthlyPayment, termMonths, 0, true);
        emit PlanCreated(wallet, assetType, itemName, monthlyPayment, termMonths);
    }

    function logPayment(address wallet, uint256 amount) external onlyAdmin {
        require(plans[wallet].active, "Plan inactive");
        plans[wallet].totalPaid += amount;
        emit PaymentLogged(wallet, amount, plans[wallet].totalPaid);
    }
}
