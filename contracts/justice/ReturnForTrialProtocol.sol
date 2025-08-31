// SPDX-License-Identifier: Civic-7
pragma solidity ^0.8.19;

/// @title ReturnForTrialProtocol.sol
/// @notice Flags individuals with pending cases who left the country, and initiates summons for local trial
contract ReturnForTrialProtocol {
    address public steward;

    struct Respondent {
        address wallet;
        string name;
        string caseTag;
        bool summoned;
        uint256 timestamp;
    }

    Respondent[] public summonsLog;

    event SummonsIssued(address indexed wallet, string name, string caseTag);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function issueSummons(address wallet, string memory name, string memory caseTag) public onlySteward {
        summonsLog.push(Respondent(wallet, name, caseTag, true, block.timestamp));
        emit SummonsIssued(wallet, name, caseTag);
    }

    function getSummons(uint256 index) public view returns (Respondent memory) {
        require(index < summonsLog.length, "Scroll not found");
        return summonsLog[index];
    }

    function totalSummons() public view returns (uint256) {
        return summonsLog.length;
    }
}
