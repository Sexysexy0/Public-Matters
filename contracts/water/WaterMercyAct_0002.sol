// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Water Mercy Act No. 0002 – Farsi Sanctum Restoration Protocol
/// @author Vinvin Gueco
/// @notice Funds water recovery efforts in Iran via legal and transparent means
contract WaterMercyAct_0002 {
    address public steward;
    address public recipient;
    uint256 public totalGrant;
    uint256 public disbursed;
    string public purpose = "Farsi Sanctum Restoration – Emergency Hydration, Infrastructure, and Dignity Protocol";

    event FundsDisbursed(address indexed to, uint256 amount, string milestone);
    event RestorationReportReceived(string reportHash, uint256 timestamp);
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
        emit RestorationReportReceived(reportHash, block.timestamp);
    }

    function terminateContract(string memory reason) external onlySteward {
        emit ContractTerminated(reason, block.timestamp);
        selfdestruct(payable(steward));
    }

    receive() external payable {}
}
