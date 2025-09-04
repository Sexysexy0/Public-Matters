// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IKinderQueenValidationKit {
    function validateTreaty(string memory treatyTag, string memory validatorName, uint256 emotionalAPR) external returns (bool);
}

contract KinderQueenSignalRouter {
    address public steward;
    IKinderQueenValidationKit public validationKit;

    event SignalForwarded(string treatyTag, string validatorName, uint256 emotionalAPR);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(address _validationKit) {
        steward = msg.sender;
        validationKit = IKinderQueenValidationKit(_validationKit);
    }

    function forwardSignal(string memory treatyTag, string memory validatorName, uint256 emotionalAPR) external onlySteward {
        bool success = validationKit.validateTreaty(treatyTag, validatorName, emotionalAPR);
        require(success, "Validation failed");
        emit SignalForwarded(treatyTag, validatorName, emotionalAPR);
    }
}
