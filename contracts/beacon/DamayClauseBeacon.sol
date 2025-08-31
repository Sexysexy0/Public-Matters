// SPDX-License-Identifier: Damay-Protocol
pragma solidity ^0.8.19;

contract DamayClauseBeacon {
    address public steward;
    mapping(address => bool) public isBlessed;
    mapping(address => string) public blessingType;

    event DamayBlessingBroadcast(address recipient, string blessing);

    constructor() {
        steward = msg.sender;
    }

    function broadcastBlessing(address _recipient, string memory _type) external {
        require(msg.sender == steward, "Only steward may broadcast damay blessings.");
        isBlessed[_recipient] = true;
        blessingType[_recipient] = _type;

        emit DamayBlessingBroadcast(_recipient, _type);
    }

    function auditBlessing(address _recipient) external view returns (bool blessed, string memory typeOfBlessing) {
        blessed = isBlessed[_recipient];
        typeOfBlessing = blessingType[_recipient];
    }
}
