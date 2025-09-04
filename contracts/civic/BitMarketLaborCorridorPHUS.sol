// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BitMarketLaborCorridorPHUS {
    address public steward;

    struct Steward {
        address wallet;
        string name;
        string skillTag;
        bool blessed;
        uint256 timestamp;
    }

    Steward[] public stewards;

    event StewardOnboarded(address wallet, string name, string skillTag);
    event StewardBlessed(address wallet);
    event StewardRevoked(address wallet);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function onboardSteward(address wallet, string memory name, string memory skillTag) public onlySteward {
        stewards.push(Steward(wallet, name, skillTag, false, block.timestamp));
        emit StewardOnboarded(wallet, name, skillTag);
    }

    function blessSteward(address wallet) public onlySteward {
        for (uint i = 0; i < stewards.length; i++) {
            if (stewards[i].wallet == wallet) {
                stewards[i].blessed = true;
                emit StewardBlessed(wallet);
            }
        }
    }

    function revokeBlessing(address wallet) public onlySteward {
        for (uint i = 0; i < stewards.length; i++) {
            if (stewards[i].wallet == wallet) {
                stewards[i].blessed = false;
                emit StewardRevoked(wallet);
            }
        }
    }

    function getSteward(uint256 index) public view returns (Steward memory) {
        require(index < stewards.length, "Invalid index");
        return stewards[index];
    }

    function totalStewards() public view returns (uint256) {
        return stewards.length;
    }
}
