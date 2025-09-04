// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KinderQueenValidationKit {
    address public steward;
    mapping(string => bool) public treatyValidated;

    event TreatyValidated(string treatyTag, string validatorName, uint256 emotionalAPR);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function validateTreaty(string memory treatyTag, string memory validatorName, uint256 emotionalAPR) external onlySteward {
        require(emotionalAPR >= 85, "APR too low for Kinder Queen validation");
        treatyValidated[treatyTag] = true;
        emit TreatyValidated(treatyTag, validatorName, emotionalAPR);
    }

    function isValidated(string memory treatyTag) external view returns (bool) {
        return treatyValidated[treatyTag];
    }
}
