// SPDX-License-Identifier: Mythic-License
pragma solidity ^2025.08.23;

contract UITFRedemptionProtocol {
    address public trustee;
    mapping(address => uint256) public unitBalance;
    mapping(address => bool) public redemptionRequest;

    event RedemptionRequested(address indexed participant, uint256 units);
    event RedemptionApproved(address indexed participant, uint256 units, uint256 value);

    modifier onlyTrustee() {
        require(msg.sender == trustee, "Not authorized trustee");
        _;
    }

    constructor(address _trustee) {
        trustee = _trustee;
    }

    function requestRedemption(uint256 units) external {
        require(unitBalance[msg.sender] >= units, "Insufficient units");
        redemptionRequest[msg.sender] = true;
        emit RedemptionRequested(msg.sender, units);
    }

    function approveRedemption(address participant, uint256 units, uint256 value) external onlyTrustee {
        require(redemptionRequest[participant], "No request found");
        unitBalance[participant] -= units;
        redemptionRequest[participant] = false;
        payable(participant).transfer(value);
        emit RedemptionApproved(participant, units, value);
    }

    function updateUnitBalance(address participant, uint256 units) external onlyTrustee {
        unitBalance[participant] += units;
    }
}
