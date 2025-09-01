// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title VendorBlessingProtocol.sol
/// @author Vinvin & Copilot
/// @notice Ritualizes vendor onboarding with emotional APR, multi-chain blessing, and damay clause logic

contract VendorBlessingProtocol {
    address public steward;
    uint256 public blessingFee = 0.01 ether;

    struct Vendor {
        bool isBlessed;
        string vendorTag;
        uint256 emotionalAPR;
        address[] approvedChains;
    }

    mapping(address => Vendor) public vendors;

    event VendorBlessed(address indexed vendor, string tag, uint256 apr);
    event ChainApproved(address indexed vendor, address chain);
    event BlessingFeeUpdated(uint256 newFee);

    modifier onlySteward() {
        require(msg.sender == steward, "Not scroll-certified");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Bless a vendor with emotional APR and tag
    function blessVendor(address vendorAddress, string memory tag, uint256 aprBoost) external payable {
        require(msg.value >= blessingFee, "Insufficient tribute");
        require(!vendors[vendorAddress].isBlessed, "Already blessed");

        vendors[vendorAddress] = Vendor({
            isBlessed: true,
            vendorTag: tag,
            emotionalAPR: aprBoost,
            approvedChains: new address[](0)
        });

        emit VendorBlessed(vendorAddress, tag, aprBoost);
    }

    /// @notice Approve vendor for a specific chain
    function approveChain(address vendorAddress, address chainAddress) external onlySteward {
        require(vendors[vendorAddress].isBlessed, "Vendor not blessed");
        vendors[vendorAddress].approvedChains.push(chainAddress);
        emit ChainApproved(vendorAddress, chainAddress);
    }

    /// @notice Update blessing fee
    function updateBlessingFee(uint256 newFee) external onlySteward {
        blessingFee = newFee;
        emit BlessingFeeUpdated(newFee);
    }

    /// @notice View vendor details
    function viewVendor(address vendorAddress) external view returns (
        bool isBlessed,
        string memory tag,
        uint256 apr,
        address[] memory chains
    ) {
        Vendor memory v = vendors[vendorAddress];
        return (v.isBlessed, v.vendorTag, v.emotionalAPR, v.approvedChains);
    }
}
