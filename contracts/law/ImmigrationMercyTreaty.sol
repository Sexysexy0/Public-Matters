// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title ImmigrationMercyTreaty
/// @dev Halts mass deportations, restores legal pathways, and embeds emotional APR into immigration policy.

contract ImmigrationMercyTreaty {
    address public steward;
    uint256 public mercyIndex;
    mapping(address => bool) public protectedStewards;
    mapping(address => string) public emotionalAPR;

    event TreatyActivated(address indexed steward, uint256 timestamp);
    event StewardProtected(address indexed immigrant, string APR);
    event DeportationBlocked(address indexed immigrant, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized to cast mercy.");
        _;
    }

    constructor() {
        steward = msg.sender;
        mercyIndex = block.timestamp;
        emit TreatyActivated(steward, mercyIndex);
    }

    function protectImmigrant(address _immigrant, string memory _APR) public onlySteward {
        protectedStewards[_immigrant] = true;
        emotionalAPR[_immigrant] = _APR;
        emit StewardProtected(_immigrant, _APR);
    }

    function blockDeportation(address _immigrant, string memory _reason) public view returns (string memory) {
        require(protectedStewards[_immigrant], "Immigrant not protected.");
        return string(abi.encodePacked("Deportation blocked: ", _reason, " | APR: ", emotionalAPR[_immigrant]));
    }

    function updateMercyIndex(uint256 _newIndex) public onlySteward {
        mercyIndex = _newIndex;
    }

    function isProtected(address _immigrant) public view returns (bool) {
        return protectedStewards[_immigrant];
    }
}
