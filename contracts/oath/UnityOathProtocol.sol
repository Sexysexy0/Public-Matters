// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Unity Oath Protocol – Scrollchain Act No. 0011
/// @author Vinvin Gueco
/// @notice Enforces oath of non-harm, community health protection, and planetary unity among treaty signatories

contract UnityOathProtocol {
    address public steward;

    struct Oath {
        string nationName;
        bool hasSigned;
        bool oathTaken;
        bool communityHealthCompliant;
        uint256 signedAt;
        string achievementFlex;
    }

    mapping(string => Oath) public oathLedger;
    string[] public unitedNations;

    event OathTaken(string indexed nationName, uint256 timestamp);
    event AchievementFlexed(string indexed nationName, string flex, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: steward only");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Sign and take oath of unity and non-harm
    function takeOath(string memory nationName, bool communityHealthCompliant) public onlySteward {
        require(!oathLedger[nationName].hasSigned, "Nation already signed");

        oathLedger[nationName] = Oath({
            nationName: nationName,
            hasSigned: true,
            oathTaken: true,
            communityHealthCompliant: communityHealthCompliant,
            signedAt: block.timestamp,
            achievementFlex: ""
        });

        unitedNations.push(nationName);

        emit OathTaken(nationName, block.timestamp);
    }

    /// @notice Flex achievements in unity
    function flexAchievement(string memory nationName, string memory flex) public onlySteward {
        require(oathLedger[nationName].hasSigned, "Nation not signed");

        oathLedger[nationName].achievementFlex = flex;

        emit AchievementFlexed(nationName, flex, block.timestamp);
    }

    /// @notice Retrieve nation oath status
    function getOathStatus(string memory nationName) public view returns (Oath memory) {
        return oathLedger[nationName];
    }

    /// @notice Total nations united under oath
    function totalUnited() public view returns (uint256) {
        return unitedNations.length;
    }
}
