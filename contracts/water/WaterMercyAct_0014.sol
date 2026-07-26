// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Water Mercy Act No. 0014 – India Hill Sanctum Hydration Protocol
/// @author Vinvin Gueco
/// @notice Funds emergency water recovery in Shimla and surrounding sanctums via turbidity override, pipeline repair, and emotional APR audits
contract WaterMercyAct_0014 {
    address public steward;
    address public recipient;
    uint256 public totalGrant;
    uint256 public disbursed;
    string public purpose = "India Hill Sanctum Hydration – Shimla Turbidity Override, Pipeline Repair, and Monsoon Mercy Protocol";

    event FundsDisbursed(address indexed to, uint256 amount, string milestone);
    event HydrationReportReceived(string reportHash, uint256 timestamp);
    event ContractTerminated(string reason, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(address _recipient, uint256 _totalGrant) {
        steward = msg.sender;
        recipient = _recipient;
        totalGrant = _totalGrant;
        disbursed = 0;
    }

    function disburseFunds(uint256 amount, string memory milestone) external onlySteward {
        require(disbursed + amount <= totalGrant, "Exceeds grant limit");
        disbursed += amount;
        (bool success, ) = payable(recipient).call{value: amount}(""); require(success, "Transfer failed");
        emit FundsDisbursed(recipient, amount, milestone);
    }

    function receiveReport(string memory reportHash) external {
        require(msg.sender == recipient, "Only recipient can submit");
        emit HydrationReportReceived(reportHash, block.timestamp);
    }

    function emergencyWithdraw(string memory reason) external onlySteward {
        require(address(this).balance > 0, "No funds to withdraw");
        uint256 balance = address(this).balance;
        (bool success, ) = payable(steward).call{value: balance}("");
        require(success, "Withdrawal failed");
        emit ContractTerminated(reason, block.timestamp);
    }
    }

    receive() external payable {}
}
