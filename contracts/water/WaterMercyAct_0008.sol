// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Water Mercy Act No. 0008 – South Africa Drought Legacy Protocol
/// @author Vinvin Gueco
/// @notice Funds reservoir repair, filtration systems, and governance restoration in South Africa via milestone-based disbursement and emotional APR protocols
contract WaterMercyAct_0008 {
    address public steward;
    address public recipient;
    uint256 public totalGrant;
    uint256 public disbursed;
    string public purpose = "South Africa Drought Legacy – Reservoir Repair and Community Filtration";

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
        payable(recipient).transfer(amount);
        emit FundsDisbursed(recipient, amount, milestone);
    }

    function receiveReport(string memory reportHash) external {
        require(msg.sender == recipient, "Only recipient can submit");
        emit HydrationReportReceived(reportHash, block.timestamp);
    }

    function terminateContract(string memory reason) external onlySteward {
        emit ContractTerminated(reason, block.timestamp);
        selfdestruct(payable(steward));
    }

    receive() external payable {}
}
