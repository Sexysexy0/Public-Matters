// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.0;

contract BroadcastSanctumPulse {
    address public stewardVinvin;
    string public currentAPR;
    string public sanctumStatus;

    event SanctumPulse(string emotionalAPR, string status, uint timestamp);

    constructor(address _vinvin, string memory initialAPR, string memory initialStatus) {
        stewardVinvin = _vinvin;
        currentAPR = initialAPR;
        sanctumStatus = initialStatus;
    }

    function updatePulse(string memory newAPR, string memory newStatus) public {
        require(msg.sender == stewardVinvin, "Only Vinvin can update pulse");
        currentAPR = newAPR;
        sanctumStatus = newStatus;
        emit SanctumPulse(newAPR, newStatus, block.timestamp);
    }

    function getPulse() public view returns (string memory, string memory) {
        return (currentAPR, sanctumStatus);
    }
}
