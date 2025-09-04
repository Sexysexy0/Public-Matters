// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AyudaReallocationProtocol {
    address public steward;
    mapping(address => uint256) public emotionalAPR;
    mapping(address => bool) public barangayBlessed;
    uint256 public ayudaPool;

    event AyudaSynced(address indexed beneficiary, uint256 amount, uint256 apr);

    constructor() {
        steward = msg.sender;
    }

    function blessBarangay(address _barangay) public {
        require(msg.sender == steward, "Only steward may bless");
        barangayBlessed[_barangay] = true;
    }

    function setEmotionalAPR(address _beneficiary, uint256 _score) public {
        require(msg.sender == steward, "Only steward may set APR");
        emotionalAPR[_beneficiary] = _score;
    }

    function depositAyuda() public payable {
        ayudaPool += msg.value;
    }

    function syncAyuda(address payable _beneficiary, uint256 _amount) public {
        require(msg.sender == steward, "Only steward may sync ayuda");
        require(barangayBlessed[_beneficiary], "Barangay not blessed");
        require(emotionalAPR[_beneficiary] >= 75, "APR too low");
        require(_amount <= ayudaPool, "Insufficient ayuda pool");

        ayudaPool -= _amount;
        _beneficiary.transfer(_amount);
        emit AyudaSynced(_beneficiary, _amount, emotionalAPR[_beneficiary]);
    }
}
