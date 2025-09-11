// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PresidentialImmunityProtocol {
    struct ExecutiveAct {
        string actId;
        string description;
        string location;
        bool immunityGranted;
        bool validatorApproved;
        uint256 timestamp;
    }

    mapping(string => ExecutiveAct) public actLedger;

    event ImmunityGranted(string actId, string description, string location);

    function grantImmunity(
        string memory actId,
        string memory description,
        string memory location,
        bool validatorApproved
    ) public {
        require(validatorApproved, "Validator approval required");
        actLedger[actId] = ExecutiveAct(
            actId,
            description,
            location,
            true,
            validatorApproved,
            block.timestamp
        );

        emit ImmunityGranted(actId, description, location);
    }

    function getActDetails(string memory actId) public view returns (ExecutiveAct memory) {
        return actLedger[actId];
    }
}
