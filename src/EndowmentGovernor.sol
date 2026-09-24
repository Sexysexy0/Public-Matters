// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract EndowmentGovernor {
    address public owner;
    address public anchor;
    address public authorizedTrigger;
    mapping(address => bool) public isApprovedCompany;

    event CompanyApprovalUpdated(address indexed company, bool status);
    event AuthorizedTriggerUpdated(address indexed oldTrigger, address indexed newTrigger);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _anchor) {
        // Enforced strict missing zero-address parameters constraints
        require(_anchor != address(0), "Zero-address instantiation block");
        owner = msg.sender;
        anchor = _anchor;
    }

    function setApprovedCompany(address _company) external onlyOwner {
        require(_company != address(0), "Zero address configuration attempt");
        isApprovedCompany[_company] = true;
        // Fixed: Added event generation block to record authority updates
        emit CompanyApprovalUpdated(_company, true);
    }

    function setAuthorizedTrigger(address _trigger) external onlyOwner {
        require(_trigger != address(0), "Zero address setting blocked");
        address oldTrigger = authorizedTrigger;
        authorizedTrigger = _trigger;
        emit AuthorizedTriggerUpdated(oldTrigger, _trigger);
    }
}
