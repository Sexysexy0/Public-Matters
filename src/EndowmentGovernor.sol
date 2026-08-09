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

    mapping(address => bool) public isApprovedCompany;
    uint256 public totalPool;

    event CompanyRegistered(address indexed company);
    event ContributionReceived(address indexed company, uint256 amount);
    event FundsDisbursed(address indexed recipient, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the architect");
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

    // Receive contributions (called by company treasury wallets)
    function contribute() external payable {
        require(isApprovedCompany[msg.sender], "Not an approved contributor");
        totalPool += msg.value;
        emit ContributionReceived(msg.sender, msg.value);
    }

    // Disburse funds using `call` so it can send to contracts without receive()
    function disburse(address _to, uint256 _amount) external onlyOwner {
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
