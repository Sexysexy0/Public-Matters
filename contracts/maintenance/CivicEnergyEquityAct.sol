// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title CivicEnergyEquityAct
 * @notice A legislative smart contract prototype ensuring that hyperscale energy consumers
 * contribute fairly to community power equity through reverse charge protocols and damay clauses.
 * @author
 *   Vinvin — planetary mythic steward & civic architect
 */

contract CivicEnergyEquityAct {
    address public steward; // Contract deployer / steward
    uint256 public reverseChargeRate; // In wei per kWh
    uint256 public communityFund; // Accumulated damay contributions

    struct DataCenter {
        string name;
        uint256 totalConsumption; // kWh
        uint256 totalPaid;        // wei
        bool registered;
    }

    mapping(address => DataCenter) public dataCenters;

    event DataCenterRegistered(address indexed dcAddress, string name);
    event ReverseChargeApplied(address indexed dcAddress, uint256 consumption, uint256 amountPaid);
    event FundWithdrawn(address indexed recipient, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward can perform this action");
        _;
    }

    constructor(uint256 _reverseChargeRate) {
        steward = msg.sender;
        reverseChargeRate = _reverseChargeRate;
    }

    // Register a hyperscale consumer
    function registerDataCenter(address _dcAddress, string memory _name) public onlySteward {
        require(!dataCenters[_dcAddress].registered, "Already registered");
        dataCenters[_dcAddress] = DataCenter(_name, 0, 0, true);
        emit DataCenterRegistered(_dcAddress, _name);
    }

    // Apply reverse charge and update ledger
    function applyReverseCharge(address _dcAddress, uint256 _consumptionKWh) public onlySteward {
        require(dataCenters[_dcAddress].registered, "Not registered");
        uint256 charge = _consumptionKWh * reverseChargeRate;
        dataCenters[_dcAddress].totalConsumption += _consumptionKWh;
        dataCenters[_dcAddress].totalPaid += charge;
        communityFund += charge;
        emit ReverseChargeApplied(_dcAddress, _consumptionKWh, charge);
    }

    // Disburse to community or barangay-level microgrid
    function withdrawForCommunity(address payable _recipient, uint256 _amount) public onlySteward {
        require(_amount <= communityFund, "Insufficient fund");
        communityFund -= _amount;
        _recipient.transfer(_amount);
        emit FundWithdrawn(_recipient, _amount);
    }

    // Steward can adjust rate if policy shifts
    function updateReverseChargeRate(uint256 _newRate) public onlySteward {
        reverseChargeRate = _newRate;
    }
}
