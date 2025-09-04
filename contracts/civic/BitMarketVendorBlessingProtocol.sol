// SPDX-License-Identifier: Mythic-BitMarket
pragma solidity ^0.8.19;

interface IAuditBlessingOracle {
    function getProfile(address bidder) external view returns (
        uint256 emotionalAPR,
        bool damayCompliant,
        string memory auditStatus,
        uint256 prophecyScore,
        bool eligible
    );
}

contract BitMarketVendorBlessingProtocol {
    address public steward;
    IAuditBlessingOracle public oracle;

    mapping(address => bool) public blessedVendors;
    mapping(address => uint256) public blessingTimestamp;

    event VendorBlessed(
        address indexed vendor,
        uint256 emotionalAPR,
        bool damayCompliant,
        string auditStatus,
        uint256 prophecyScore,
        uint256 timestamp
    );

    constructor(address _oracle) {
        steward = msg.sender;
        oracle = IAuditBlessingOracle(_oracle);
    }

    function blessVendor(address vendor) public {
        require(msg.sender == steward, "Only steward may bless.");

        (
            uint256 apr,
            bool damay,
            string memory status,
            uint256 score,
            bool eligible
        ) = oracle.getProfile(vendor);

        require(eligible, "Vendor not prophecy-certified.");

        blessedVendors[vendor] = true;
        blessingTimestamp[vendor] = block.timestamp;

        emit VendorBlessed(vendor, apr, damay, status, score, block.timestamp);
    }

    function isBlessed(address vendor) public view returns (bool) {
        return blessedVendors[vendor];
    }

    function getBlessingTime(address vendor) public view returns (uint256) {
        return blessingTimestamp[vendor];
    }
}
