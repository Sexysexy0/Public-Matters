// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BananaGrowth
/// @notice Covenant contract to safeguard and incentivize banana industry growth in Mindanao
contract BananaGrowth {
    address public owner;

    struct Incentive {
        string program;      // e.g. "Export Subsidy", "Local Processing Plant"
        uint256 amount;      // incentive value
        string beneficiary;  // e.g. "Farmers Cooperative", "AgriTech Startup"
        uint256 timestamp;
    }

    Incentive[] public incentives;

    event IncentiveLogged(string program, uint256 amount, string beneficiary, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new incentive for banana industry growth
    function logIncentive(string memory program, uint256 amount, string memory beneficiary) public onlyOwner {
        Incentive memory newIncentive = Incentive(program, amount, beneficiary, block.timestamp);
        incentives.push(newIncentive);
        emit IncentiveLogged(program, amount, beneficiary, block.timestamp);
    }

    function getIncentive(uint256 index) public view returns (string memory, uint256, string memory, uint256) {
        Incentive memory i = incentives[index];
        return (i.program, i.amount, i.beneficiary, i.timestamp);
    }

    function getIncentiveCount() public view returns (uint256) {
        return incentives.length;
    }
}
