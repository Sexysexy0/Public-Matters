// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EndowmentGovernor
 * @dev Central treasury for the 1-5% corporate contribution pool.
 * Uses low-level call for versatile ETH transfers.
 */
contract EndowmentGovernor {
    address public immutable owner;
    address public anchor;
    address public authorizedTrigger;

    mapping(address => bool) public isApprovedCompany;
    uint256 public totalPool;

    event CompanyRegistered(address indexed company);
    event ContributionReceived(address indexed company, uint256 amount);
    event FundsDisbursed(address indexed recipient, uint256 amount);
    event AuthorizedTriggerUpdated(address indexed newTrigger);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the architect");
        _;
    }

    modifier onlyOwnerOrTrigger() {
        require(msg.sender == owner || msg.sender == authorizedTrigger, "Not authorized to disburse");
        _;
    }

    constructor(address _anchor) {
        owner = msg.sender;
        anchor = _anchor;
    }

    // Register a company under your leadership
    function registerCompany(address _company) external onlyOwner {
        isApprovedCompany[_company] = true;
        emit CompanyRegistered(_company);
    }

    // Set the contract allowed to trigger disbursements automatically (e.g. PeopleSovereigntyCovenant)
    function setAuthorizedTrigger(address _trigger) external onlyOwner {
        authorizedTrigger = _trigger;
        emit AuthorizedTriggerUpdated(_trigger);
    }

    // Receive contributions (called by company treasury wallets)
    function contribute() external payable {
        require(isApprovedCompany[msg.sender], "Not an approved contributor");
        totalPool += msg.value;
        emit ContributionReceived(msg.sender, msg.value);
    }

    // Disburse funds using `call` so it can send to contracts without receive()
    // Callable by owner directly, or by the authorized trigger contract (e.g. the Covenant)
    function disburse(address _to, uint256 _amount) external onlyOwnerOrTrigger {
        require(_amount <= totalPool, "Insufficient pool balance");
        totalPool -= _amount;
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Transfer failed");
        emit FundsDisbursed(_to, _amount);
    }

    // Allow the contract to receive ETH directly
    receive() external payable {
        totalPool += msg.value;
        emit ContributionReceived(msg.sender, msg.value);
    }
}
