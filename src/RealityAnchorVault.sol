// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RealityAnchorVault
 * @notice Ensures that liabilities and obligations cannot be bent or avoided. Paid in full.
 */
contract RealityAnchorVault {
    
    address public immutable anchorMaster;
    mapping(address => uint256) public outstandingLiabilities;

    event LiabilityIncurred(address indexed debtor, uint256 amount);
    event PaidInFull(address indexed debtor, uint256 amount);

    constructor() {
        anchorMaster = msg.sender;
    }

    modifier onlyMaster() {
        require(msg.sender == anchorMaster, "Only anchor master can assign reality parameters");
        _;
    }

    /**
     * @notice Assigns a mandatory liability that must be settled in full.
     */
    function assignLiability(address _debtor, uint256 _amount) external onlyMaster {
        outstandingLiabilities[_debtor] += _amount;
        emit LiabilityIncurred(_debtor, _amount);
    }

    /**
     * @notice Settles the liability completely. No shortcuts, no distortions.
     */
    function payInFull() external payable {
        uint256 debt = outstandingLiabilities[msg.sender];
        require(debt > 0, "No outstanding liabilities");
        require(msg.value >= debt, "Insufficient payment to settle reality");

        outstandingLiabilities[msg.sender] = 0;
        emit PaidInFull(msg.sender, debt);

        // Refund excess if any
        if (msg.value > debt) {
            (bool success, ) = payable(msg.sender).call{value: msg.value - debt}("");
            require(success, "Refund failed");
        }
    }
}
