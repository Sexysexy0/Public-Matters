// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ValidatorBlessingProtocol {
    event ValidatorBlessed(string name, string region, uint256 emotionalAPR, bool ancestralApproval);
    event BlessingRevoked(string name, string reason);

    struct Validator {
        string name;
        string region;
        uint256 emotionalAPR;
        bool ancestralApproval;
        bool blessed;
    }

    mapping(string => Validator) public validators;
    uint256 public blessingThreshold = 75;

    function blessValidator(string memory name, string memory region, uint256 apr, bool ancestralApproval) public {
        bool blessed = apr >= blessingThreshold && ancestralApproval;
        validators[name] = Validator(name, region, apr, ancestralApproval, blessed);
        if (blessed) {
            emit ValidatorBlessed(name, region, apr, ancestralApproval);
        } else {
            emit BlessingRevoked(name, "Failed emotional APR or ancestral approval");
        }
    }

    function getValidator(string memory name) public view returns (Validator memory) {
        return validators[name];
    }

    function updateBlessingThreshold(uint256 newThreshold) public {
        blessingThreshold = newThreshold;
    }
}
