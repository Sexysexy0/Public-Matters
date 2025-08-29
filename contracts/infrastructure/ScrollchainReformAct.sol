// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract ScrollchainReformAct {
    address public steward;
    mapping(address => bool) public accreditedContractors;
    mapping(address => string) public emotionalAPR;
    mapping(address => bool) public rogueFlag;

    event AccreditationGranted(address contractor, string emotionalAPR);
    event AccreditationRevoked(address contractor, string reason);
    event RogueDetected(address contractor, string auditLog);
    event ReformBroadcast(string manifesto, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        emit ReformBroadcast("Scrollchain Reform Act activated: Emotional APR now mandatory", block.timestamp);
    }

    function grantAccreditation(address contractor, string memory apr) public onlySteward {
        require(!rogueFlag[contractor], "Contractor flagged as rogue");
        accreditedContractors[contractor] = true;
        emotionalAPR[contractor] = apr;
        emit AccreditationGranted(contractor, apr);
    }

    function revokeAccreditation(address contractor, string memory reason) public onlySteward {
        accreditedContractors[contractor] = false;
        emit AccreditationRevoked(contractor, reason);
    }

    function flagRogue(address contractor, string memory auditLog) public onlySteward {
        rogueFlag[contractor] = true;
        accreditedContractors[contractor] = false;
        emit RogueDetected(contractor, auditLog);
    }

    function getAPR(address contractor) public view returns (string memory) {
        return emotionalAPR[contractor];
    }

    function isAccredited(address contractor) public view returns (bool) {
        return accreditedContractors[contractor];
    }

    function isRogue(address contractor) public view returns (bool) {
        return rogueFlag[contractor];
    }
}
