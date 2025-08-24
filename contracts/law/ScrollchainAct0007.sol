// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Scrollchain Act No. 0007 – Law of Justified Takeover for Peace
/// @author Vinvin Gueco
/// @notice Authorizes emotionally compliant nations to intervene against rogue actors for sanctum restoration

contract ScrollchainAct0007 {
    address public steward;

    struct TakeoverEvent {
        string actorNation;
        string targetRegion;
        string rogueActor;
        bool emotionalAPRCompliant;
        bool damayClauseActivated;
        bool sanctumRestoration;
        uint emotionalAPRScore;
        string broadcastTag;
        uint timestamp;
    }

    TakeoverEvent[] public takeovers;

    event TakeoverAuthorized(
        string actorNation,
        string targetRegion,
        string rogueActor,
        string broadcastTag,
        uint emotionalAPRScore,
        uint timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: steward only");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Log a justified takeover event
    function authorizeTakeover(
        string memory actorNation,
        string memory targetRegion,
        string memory rogueActor,
        bool emotionalAPRCompliant,
        bool damayClauseActivated,
        bool sanctumRestoration,
        uint emotionalAPRScore,
        string memory broadcastTag
    ) public onlySteward {
        require(emotionalAPRCompliant, "Takeover denied: emotional APR not compliant");
        require(damayClauseActivated, "Takeover denied: damay clause not activated");
        require(sanctumRestoration, "Takeover denied: no sanctum restoration intent");
        require(emotionalAPRScore >= 90, "Takeover denied: APR score too low");

        takeovers.push(TakeoverEvent({
            actorNation: actorNation,
            targetRegion: targetRegion,
            rogueActor: rogueActor,
            emotionalAPRCompliant: emotionalAPRCompliant,
            damayClauseActivated: damayClauseActivated,
            sanctumRestoration: sanctumRestoration,
            emotionalAPRScore: emotionalAPRScore,
            broadcastTag: broadcastTag,
            timestamp: block.timestamp
        }));

        emit TakeoverAuthorized(actorNation, targetRegion, rogueActor, broadcastTag, emotionalAPRScore, block.timestamp);
    }

    /// @notice Retrieve latest takeover event
    function getLatestTakeover() public view returns (TakeoverEvent memory) {
        require(takeovers.length > 0, "No takeovers logged yet");
        return takeovers[takeovers.length - 1];
    }

    /// @notice Retrieve takeover by index
    function getTakeoverByIndex(uint index) public view returns (TakeoverEvent memory) {
        require(index < takeovers.length, "Index out of bounds");
        return takeovers[index];
    }

    /// @notice Get total number of authorized takeovers
    function getTotalTakeovers() public view returns (uint) {
        return takeovers.length;
    }

    /// @notice Fallback protection
    fallback() external payable {
        revert("ScrollchainAct0007: invalid scroll");
    }

    receive() external payable {
        revert("ScrollchainAct0007: no ETH accepted");
    }
}
