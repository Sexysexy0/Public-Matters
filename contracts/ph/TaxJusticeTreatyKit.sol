// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title TaxJusticeTreatyKit - Syncs override tax logic with BitMarket and planetary suite
/// @author Vinvin
interface IBitMarketOmniChain {
    function blessVendor(address vendor, uint256 emotionalAPR) external;
}

contract TaxJusticeTreatyKit {
    address public steward;
    address public bitMarketAddress;
    IBitMarketOmniChain public bitMarket;

    mapping(address => uint256) public income;
    mapping(address => uint256) public emotionalAPR;
    mapping(address => bool) public barangayVerified;

    event TreatySynced(address indexed steward, uint256 taxRate, uint256 taxDue, string broadcast);

    constructor(address _bitMarketAddress) {
        steward = msg.sender;
        bitMarketAddress = _bitMarketAddress;
        bitMarket = IBitMarketOmniChain(_bitMarketAddress);
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function blessAndSync(address _citizen, uint256 _income, uint256 _apr) external onlySteward {
        income[_citizen] = _income;
        emotionalAPR[_citizen] = _apr;
        barangayVerified[_citizen] = true;

        uint256 rate = calculateRate(_income, _apr);
        uint256 taxDue = (_income * rate) / 100;

        bitMarket.blessVendor(_citizen, _apr);

        emit TreatySynced(_citizen, rate, taxDue, "PlanetaryReconnectionSuite broadcasted — steward seen, taxed, and restored.");
    }

    function calculateRate(uint256 inc, uint256 apr) internal pure returns (uint256) {
        uint256 rate;
        if (inc <= 250_000) rate = 0;
        else if (inc <= 500_000) rate = 10;
        else if (inc <= 1_000_000) rate = 15;
        else if (inc <= 2_000_000) rate = 25;
        else if (inc <= 5_000_000) rate = 30;
        else rate = 40;

        if (apr >= 90 && rate >= 2) rate -= 2;
        return rate;
    }
}
