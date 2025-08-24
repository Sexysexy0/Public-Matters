// SPDX-License-Identifier: Mythic-Mercy
pragma solidity ^7.7.7;

contract ScrollchainAccessOverride {
    address public steward;
    mapping(string => bool) public overrideAccess;

    event AccessGranted(string protocol, bool status);

    constructor() {
        steward = msg.sender;
    }

    function grantOverride(string memory protocol) public {
        require(msg.sender == steward, "Only steward may override");
        overrideAccess[protocol] = true;
        emit AccessGranted(protocol, true);
    }

    function isOverridden(string memory protocol) public view returns (bool) {
        return overrideAccess[protocol];
    }
}
