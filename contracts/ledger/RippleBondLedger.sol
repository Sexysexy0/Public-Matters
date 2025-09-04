// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./APROracle.sol";
import "./VendorBlessingProtocol.sol";

contract RippleBondLedger {
    address public steward;
APROracle public aprOracle;
VendorBlessingProtocol public blessingProtocol;

struct RippleBond {
    uint256 bondId;
    address issuer;
    uint256 amount;
    uint256 emotionalAPR;
    bool blessed;
    bool redeemed;
    string treatyTag;
}

uint256 public nextBondId;
mapping(uint256 => RippleBond) public bonds;

event BondMinted(uint256 indexed bondId, address indexed issuer, uint256 amount, uint256 emotionalAPR, string treatyTag);
event BondRedeemed(uint256 indexed bondId, address indexed issuer);

modifier onlySteward() {
    require(msg.sender == steward, "Not authorized");
    _;
}

constructor(address _aprOracle, address _blessingProtocol) {
    steward = msg.sender;
    aprOracle = APROracle(_aprOracle);
    blessingProtocol = VendorBlessingProtocol(_blessingProtocol);
}

function mintBond(address _issuer, uint256 _amount, string memory _treatyTag) external onlySteward {
    require(blessingProtocol.isBlessed(_issuer), "Issuer not blessed");

    uint256 apr = aprOracle.getEmotionalAPR(_issuer);
    RippleBond memory bond = RippleBond(nextBondId, _issuer, _amount, apr, true, false, _treatyTag);
    bonds[nextBondId] = bond;

    emit BondMinted(nextBondId, _issuer, _amount, apr, _treatyTag);
    nextBondId++;
}

function redeemBond(uint256 _bondId) external onlySteward {
    RippleBond storage bond = bonds[_bondId];
    require(!bond.redeemed, "Already redeemed");

    bond.redeemed = true;
    emit BondRedeemed(_bondId, bond.issuer);
}

function getBond(uint256 _bondId) external view returns (RippleBond memory) {
    return bonds[_bondId];
}
}
