// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PublicBenefitVisibility
/// @notice Covenant contract to make tax usage transparent and visible to citizens
contract PublicBenefitVisibility {
    address public owner;

    struct Benefit {
        string project;      // e.g. "School Building", "Hospital Upgrade"
        uint256 amount;      // funds allocated
        string description;  // details of the project
        uint256 timestamp;
    }

    Benefit[] public benefits;

    event BenefitLogged(string project, uint256 amount, string description, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function logBenefit(string memory project, uint256 amount, string memory description) public onlyOwner {
        Benefit memory newBenefit = Benefit(project, amount, description, block.timestamp);
        benefits.push(newBenefit);
        emit BenefitLogged(project, amount, description, block.timestamp);
    }

    function getBenefit(uint256 index) public view returns (string memory, uint256, string memory, uint256) {
        Benefit memory b = benefits[index];
        return (b.project, b.amount, b.description, b.timestamp);
    }

    function getBenefitCount() public view returns (uint256) {
        return benefits.length;
    }
}
