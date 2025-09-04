// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./APROracle.sol";
import "./VendorBlessingProtocol.sol";

contract BitMarketGridBlessing {
    address public steward;
APROracle public aprOracle;
VendorBlessingProtocol public blessingProtocol;

struct GridVendor {
    string name;
    string gridType; // solar, wind, hydro, biomass, signal
    bool blessed;
    uint256 emotionalAPR;
}

mapping(address => GridVendor) public vendors;

event GridBlessed(address indexed vendor, string gridType, uint256 emotionalAPR);
event BlessingRevoked(address indexed vendor);

modifier onlySteward() {
    require(msg.sender == steward, "Not authorized");
    _;
}

constructor(address _oracle, address _protocol) {
    steward = msg.sender;
    aprOracle = APROracle(_oracle);
    blessingProtocol = VendorBlessingProtocol(_protocol);
}

function blessGridVendor(address _vendor, string memory _name, string memory _gridType) external onlySteward {
    require(!vendors[_vendor].blessed, "Already blessed");

    uint256 apr = aprOracle.getEmotionalAPR(_vendor);
    vendors[_vendor] = GridVendor(_name, _gridType, true, apr);

    blessingProtocol.registerBlessing(_vendor, _gridType, apr);
    emit GridBlessed(_vendor, _gridType, apr);
}

function revokeBlessing(address _vendor) external onlySteward {
    require(vendors[_vendor].blessed, "Not blessed");

    vendors[_vendor].blessed = false;
    blessingProtocol.revokeBlessing(_vendor);
    emit BlessingRevoked(_vendor);
}

function getVendorAPR(address _vendor) external view returns (uint256) {
    return vendors[_vendor].emotionalAPR;
}
}
