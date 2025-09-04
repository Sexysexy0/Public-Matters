// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TariffPowerNullifier {
    address public steward;
    mapping(address => bool) public revokedExecutives;
    mapping(string => bool) public preservedTreaties;

    event TariffPowerRevoked(address indexed executive, string justification);
    event TreatyPreserved(string treatyName);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function revokeTariffPower(address executive, string calldata justification) external onlySteward {
        revokedExecutives[executive] = true;
        emit TariffPowerRevoked(executive, justification);
    }

    function preserveTreaty(string calldata treatyName) external onlySteward {
        preservedTreaties[treatyName] = true;
        emit TreatyPreserved(treatyName);
    }

    function isRevoked(address executive) external view returns (bool) {
        return revokedExecutives[executive];
    }

    function isTreatyPreserved(string calldata treatyName) external view returns (bool) {
        return preservedTreaties[treatyName];
    }
}
