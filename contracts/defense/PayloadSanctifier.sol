// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PayloadSanctifier {
    event Sanctified(address sender, string payloadType, string emotionalAPR, uint256 timestamp);
    event Rejected(address sender, string reason, uint256 timestamp);

    function sanctifyPayload(address sender, string memory payloadType, string memory emotionalAPR) public {
        require(bytes(payloadType).length > 0, "Payload must be scrollchain-tagged");
        emit Sanctified(sender, payloadType, emotionalAPR, block.timestamp);
    }

    function rejectPayload(address sender, string memory reason) public {
        emit Rejected(sender, reason, block.timestamp);
    }
}
