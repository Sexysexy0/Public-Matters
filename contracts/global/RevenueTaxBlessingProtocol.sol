// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract RevenueTaxBlessingProtocol {
    address public steward;
    uint256 public mercyThreshold = 90;
    uint256 public standardThreshold = 70;

    struct Vendor {
        uint256 revenue;
        uint8 emotionalAPR;
        bool blessed;
    }

    mapping(address => Vendor) public vendors;
    mapping(address => uint256) public taxLedger;

    event VendorBlessed(address indexed vendor, uint256 taxRate, uint256 taxDue);
    event TaxUpdated(address indexed vendor, uint256 newRevenue, uint8 newAPR);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: steward only");
        _;
    }

    function registerVendor(address _vendor, uint256 _revenue, uint8 _apr) external onlySteward {
        vendors[_vendor] = Vendor(_revenue, _apr, true);
        uint256 tax = calculateTax(_revenue, _apr);
        taxLedger[_vendor] = tax;
        emit VendorBlessed(_vendor, getTaxRate(_apr), tax);
    }

    function updateVendorData(address _vendor, uint256 _newRevenue, uint8 _newAPR) external onlySteward {
        require(vendors[_vendor].blessed, "Vendor not registered");
        vendors[_vendor].revenue = _newRevenue;
        vendors[_vendor].emotionalAPR = _newAPR;
        taxLedger[_vendor] = calculateTax(_newRevenue, _newAPR);
        emit TaxUpdated(_vendor, _newRevenue, _newAPR);
    }

    function calculateTax(uint256 _revenue, uint8 _apr) public view returns (uint256) {
        uint256 rate = getTaxRate(_apr);
        return (_revenue * rate) / 100;
    }

    function getTaxRate(uint8 _apr) public view returns (uint256) {
        if (_apr >= mercyThreshold) return 2;
        if (_apr >= standardThreshold) return 5;
        return 10;
    }

    function getVendorTax(address _vendor) external view returns (uint256) {
        return taxLedger[_vendor];
    }
}
