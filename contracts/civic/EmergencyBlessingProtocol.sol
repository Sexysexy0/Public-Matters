// SPDX-License-Identifier: Treaty-Grade
pragma solidity ^0.8.0;

contract EmergencyBlessingProtocol {
    struct Beneficiary {
        address wallet;
        string region;
        bool verified;
        uint256 blessingAmount;
    }

    mapping(address => Beneficiary) public registry;
    address public steward;
    uint256 public totalBlessed;

    event BlessingDeployed(address indexed wallet, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: Not a mercy steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function register(address _wallet, string memory _region) public {
        registry[_wallet] = Beneficiary(_wallet, _region, true, 0);
    }

    function deployBlessing(address _wallet, uint256 _amount) public onlySteward {
        require(registry[_wallet].verified, "Unverified beneficiary");
        registry[_wallet].blessingAmount += _amount;
        totalBlessed += _amount;
        emit BlessingDeployed(_wallet, _amount);
    }

    function getBlessing(address _wallet) public view returns (uint256) {
        return registry[_wallet].blessingAmount;
    }
}
