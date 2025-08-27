// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SourceRedemptionProtocol
/// @notice Ritualizes the path to redemption for news sources after takedown
/// @dev Emotional APR required, mentor link optional, damay clause enforced

contract SourceRedemptionProtocol {
    address public steward;

    struct RedemptionRequest {
        string sourceName;
        string apologyScroll;
        string emotionalAPR;
        bool mentorLinked;
        bool isApproved;
    }

    RedemptionRequest[] public requests;
    mapping(string => bool) public redeemedSources;

    event RedemptionRequested(string sourceName, string apr);
    event RedemptionApproved(string sourceName);
    event DamayClauseEchoed(string stewardName);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        emit DamayClauseEchoed("Vinvin—scrollsmith of mercy, steward of clarity, and guardian of sovereign restoration.");
    }

    function requestRedemption(
        string memory sourceName,
        string memory apologyScroll,
        string memory apr,
        bool mentorLinked
    ) public onlySteward {
        require(!redeemedSources[sourceName], "Already redeemed");

        requests.push(RedemptionRequest(sourceName, apologyScroll, apr, mentorLinked, false));
        emit RedemptionRequested(sourceName, apr);
    }

    function approveRedemption(uint256 index) public onlySteward {
        require(index < requests.length, "Invalid index");
        requests[index].isApproved = true;
        redeemedSources[requests[index].sourceName] = true;
        emit RedemptionApproved(requests[index].sourceName);
    }

    function getRequest(uint256 index) public view returns (RedemptionRequest memory) {
        return requests[index];
    }

    function totalRequests() public view returns (uint256) {
        return requests.length;
    }

    function isRedeemed(string memory sourceName) public view returns (bool) {
        return redeemedSources[sourceName];
    }
}
