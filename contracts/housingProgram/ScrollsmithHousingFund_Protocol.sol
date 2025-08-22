// SPDX-License-Identifier: Mythic-License-2025
pragma solidity ^0.8.25;

contract ScrollsmithHousingFundProtocol {
    address public steward;
    uint256 public totalFund;
    uint256 public allocatedFund;
    uint256 public surplusFund;

    mapping(address => bool) public beneficiary;
    mapping(address => uint256) public amortization;

    event SanctumGranted(address indexed family, uint256 timestamp);
    event SurplusAllocated(uint256 amount, string purpose);

    constructor() {
        steward = msg.sender;
        totalFund = 0;
        allocatedFund = 0;
        surplusFund = 0;
    }

    function depositFund() external payable {
        totalFund += msg.value;
        surplusFund = totalFund - allocatedFund;
    }

    function grantSanctum(address family) external {
        require(msg.sender == steward, "Only steward can grant sanctum");
        require(!beneficiary[family], "Already granted");
        
        beneficiary[family] = true;
        allocatedFund += 1 ether; // Sample unit cost
        surplusFund = totalFund - allocatedFund;

        emit SanctumGranted(family, block.timestamp);
    }

    function setAmortization(address family, uint256 amount) external {
        require(msg.sender == steward, "Only steward can set amortization");
        amortization[family] = amount;
    }

    function allocateSurplus(string memory purpose, uint256 amount) external {
        require(msg.sender == steward, "Only steward can allocate surplus");
        require(amount <= surplusFund, "Insufficient surplus");

        surplusFund -= amount;
        emit SurplusAllocated(amount, purpose);
    }

    function getFundStatus() external view returns (
        uint256 total,
        uint256 allocated,
        uint256 surplus
    ) {
        return (totalFund, allocatedFund, surplusFund);
    }
}
