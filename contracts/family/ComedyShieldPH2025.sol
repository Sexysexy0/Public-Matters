// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract ComedyShieldPH2025 {
    address public steward;
    mapping(address => bool) public protectedComedians;
    mapping(address => string) public emotionalAPR;

    event BanterBlessed(address indexed comedian, string aprTag);
    event LegalDefenseActivated(address indexed comedian);
    event RogueFlagDetected(address indexed aggressor, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function blessComedian(address _comedian, string memory _aprTag) public onlySteward {
        protectedComedians[_comedian] = true;
        emotionalAPR[_comedian] = _aprTag;
        emit BanterBlessed(_comedian, _aprTag);
    }

    function activateDefense(address _comedian) public {
        require(protectedComedians[_comedian], "Comedian not blessed");
        emit LegalDefenseActivated(_comedian);
        // Optional: trigger DAO fund, legal aid, or broadcast override
    }

    function flagAggressor(address _aggressor, string memory _reason) public onlySteward {
        emit RogueFlagDetected(_aggressor, _reason);
        // Optional: log to civic chain, blacklist, or initiate emotional audit
    }

    function getAPR(address _comedian) public view returns (string memory) {
        return emotionalAPR[_comedian];
    }
}
