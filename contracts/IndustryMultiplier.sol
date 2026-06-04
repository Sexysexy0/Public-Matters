// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IndustryMultiplier
/// @notice Safeguard contract to prioritize manufacturing equity
contract IndustryMultiplier {
    address public owner;

    struct Industry {
        string name;
        bool isManufacturing;
        uint256 multiplier; // ripple effect jobs created
    }

    mapping(string => Industry) public industries;

    event IndustryRegistered(string name, bool isManufacturing, uint256 multiplier);
    event EquityEnforced(string name, uint256 multiplier);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerIndustry(string memory name, bool isManufacturing, uint256 multiplier) public onlyOwner {
        industries[name] = Industry(name, isManufacturing, multiplier);
        emit IndustryRegistered(name, isManufacturing, multiplier);
    }

    function enforceEquity(string memory name) public onlyOwner {
        Industry memory ind = industries[name];
        require(bytes(ind.name).length > 0, "Industry not registered");
        require(ind.isManufacturing, "Not a manufacturing industry");
        emit EquityEnforced(ind.name, ind.multiplier);
    }
}
