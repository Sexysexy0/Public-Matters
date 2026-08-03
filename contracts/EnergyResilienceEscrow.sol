// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EnergyResilienceEscrow
 * @dev On-Chain Fuel Reserve Stabilization & Emergency Energy Subsidy Protocol
 */
contract EnergyResilienceEscrow {
    address public rootAdmin;
    uint256 public priceCeilingThreshold; // Price trigger point for subsidy release
    uint256 public totalBufferReserve;

    struct SubsidyClaim {
        address beneficiary;
        uint256 amount;
        uint256 timestamp;
        bool isClaimed;
    }

    mapping(address => bool) public verifiedOperators;
    mapping(address => uint256) public operatorAllocations;

    event ReserveDeposited(address indexed depositor, uint256 amount);
    event SubsidyAllocated(address indexed operator, uint256 amount);
    event SubsidyClaimed(address indexed operator, uint256 amount);
    event PriceCeilingUpdated(uint256 newThreshold);

    modifier onlyAdmin() {
        require(msg.sender == rootAdmin, "ERE: Only Root Admin authorized");
        _;
    }

    constructor(uint256 _priceCeilingThreshold) payable {
        rootAdmin = msg.sender;
        priceCeilingThreshold = _priceCeilingThreshold;
        totalBufferReserve = msg.value;
    }

    receive() external payable {
        totalBufferReserve += msg.value;
        emit ReserveDeposited(msg.sender, msg.value);
    }

    function registerOperator(address _operator) external onlyAdmin {
        verifiedOperators[_operator] = true;
    }

    function triggerEmergencySubsidy(
        address[] calldata _operators,
        uint256[] calldata _amounts,
        uint256 _currentGlobalOilPrice
    ) external onlyAdmin {
        require(_currentGlobalOilPrice >= priceCeilingThreshold, "ERE: Oil price below emergency threshold");
        require(_operators.length == _amounts.length, "ERE: Mismatched input lengths");

        for (uint256 i = 0; i < _operators.length; i++) {
            address operator = _operators[i];
            uint256 amount = _amounts[i];

            if (verifiedOperators[operator] && totalBufferReserve >= amount) {
                totalBufferReserve -= amount;
                operatorAllocations[operator] += amount;
                emit SubsidyAllocated(operator, amount);
            }
        }
    }

    function claimSubsidy() external {
        uint256 amount = operatorAllocations[msg.sender];
        require(amount > 0, "ERE: No allocated subsidy available");

        operatorAllocations[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "ERE: Transfer failed");

        emit SubsidyClaimed(msg.sender, amount);
    }

    function updatePriceCeiling(uint256 _newThreshold) external onlyAdmin {
        priceCeilingThreshold = _newThreshold;
        emit PriceCeilingUpdated(_newThreshold);
    }
}
