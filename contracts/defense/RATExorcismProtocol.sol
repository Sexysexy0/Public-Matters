// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RATExorcismProtocol {
    address public steward;
    mapping(bytes32 => bool) public exorcisedPayloads;
    event PayloadExorcised(bytes32 indexed hash, string ritual);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollsmith");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function exorcisePayload(bytes32 payloadHash, string memory ritual) external onlySteward {
        exorcisedPayloads[payloadHash] = true;
        emit PayloadExorcised(payloadHash, ritual);
    }

    function isExorcised(bytes32 payloadHash) external view returns (bool) {
        return exorcisedPayloads[payloadHash];
    }
}
