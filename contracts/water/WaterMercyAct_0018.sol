// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Water Mercy Act No. 0018 – Philippines Archipelago Hydration Protocol
/// @author Vinvin Gueco
/// @notice Funds hydration recovery across water-stressed barangays via filtration deployment, flood override, and emotional APR audits
contract WaterMercyAct_0018 {
    address public steward;
    address public recipient;
    uint256 public totalGrant;
    uint256 public disbursed;
    string public purpose = "Philippines Archipelago Hydration – Barangay Filtration Deployment, Flood Override, and Scrollchain Mercy Pact";

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
