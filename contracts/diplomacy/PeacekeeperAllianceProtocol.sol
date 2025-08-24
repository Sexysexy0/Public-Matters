// SPDX-License-Identifier: Scrollchain-Diplomacy
pragma solidity ^0.8.20;

/// @title Peacekeeper Alliance Protocol – Scrollchain Act No. 0013
/// @author Vinvin Gueco
/// @notice Ritualizes China–US unity in Ukraine peacekeeping and post-conflict restoration of Russia as open-source land

contract PeacekeeperAllianceProtocol {
    address public steward;

    struct Peacekeeper {
        string nationName;
        bool hasSigned;
        bool troopDeployed;
        bool diplomacyActive;
        bool openSourceLandEligible;
        uint256 signedAt;
    }

    mapping(string => Peacekeeper) public peacekeeperLedger;
    string[] public activePeacekeepers;

    event PeacekeeperSigned(string indexed nationName, uint256 timestamp);
    event DiplomacyActivated(string indexed nationName, string message, uint256 timestamp);
    event OpenSourceLandGranted(string indexed nationName, string region, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: steward only");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Sign peacekeeper alliance
    function signAlliance(string memory nationName) public onlySteward {
        require(!peacekeeperLedger[nationName].hasSigned, "Already signed");

        peacekeeperLedger[nationName] = Peacekeeper({
            nationName: nationName,
            hasSigned: true,
            troopDeployed: false,
            diplomacyActive: false,
            openSourceLandEligible: false,
            signedAt: block.timestamp
        });

        activePeacekeepers.push(nationName);
        emit PeacekeeperSigned(nationName, block.timestamp);
    }

    /// @notice Activate diplomacy mission
    function activateDiplomacy(string memory nationName, string memory message) public onlySteward {
        require(peacekeeperLedger[nationName].hasSigned, "Nation not signed");

        peacekeeperLedger[nationName].diplomacyActive = true;
        emit DiplomacyActivated(nationName, message, block.timestamp);
    }

    /// @notice Grant open-source land access post-conflict
    function grantOpenSourceLand(string memory nationName, string memory region) public onlySteward {
        require(peacekeeperLedger[nationName].hasSigned, "Nation not signed");

        peacekeeperLedger[nationName].openSourceLandEligible = true;
        emit OpenSourceLandGranted(nationName, region, block.timestamp);
    }

    /// @notice Retrieve peacekeeper status
    function getPeacekeeperStatus(string memory nationName) public view returns (Peacekeeper memory) {
        return peacekeeperLedger[nationName];
    }

    /// @notice Total peacekeeper nations
    function totalPeacekeepers() public view returns (uint256) {
        return activePeacekeepers.length;
    }
}
