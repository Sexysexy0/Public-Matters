// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SOCE Audit Arc: log Statements of Contributions and Expenditures
contract SOCEAudit {
    struct SOCE {
        uint256 id;
        string candidate;
        string evidenceURI;
        address filedBy;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => SOCE) public soces;
    mapping(address => bool) public validators;
    address public steward;

    event SOCEFiled(uint256 indexed id, string candidate);

    constructor() {
        steward = msg.sender;
        validators[steward] = true;
    }

    function addValidator(address _validator) external {
        require(msg.sender == steward, "Only steward");
        validators[_validator] = true;
    }

    function fileSOCE(string calldata _candidate, string calldata _evidenceURI) external {
        require(validators[msg.sender], "Not validator");
        soces[nextId] = SOCE(nextId, _candidate, _evidenceURI, msg.sender, block.timestamp);
        emit SOCEFiled(nextId, _candidate);
        nextId++;
    }
}
