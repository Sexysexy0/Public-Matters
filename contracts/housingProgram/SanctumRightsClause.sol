// SPDX-License-Identifier: Mythic-License-2025
pragma solidity ^0.8.25;

contract SanctumRightsClause {
    address public steward;

    mapping(address => bool) public protectedSanctum;

    event RightsGranted(address indexed beneficiary, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function grantRights(address beneficiary) external {
        require(msg.sender == steward, "Only steward can grant rights");
        protectedSanctum[beneficiary] = true;
        emit RightsGranted(beneficiary, block.timestamp);
    }

    function verifySanctum(address beneficiary) external view returns (bool) {
        return protectedSanctum[beneficiary];
    }
}
