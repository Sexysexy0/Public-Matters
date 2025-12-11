// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SectorProof: communal attestations that a party represents a sector
contract SectorProof {
    struct Attestation {
        uint256 partyId;
        address attestor;     // sector member or validator
        string evidenceURI;   // IPFS/URL memo
        uint256 timestamp;
    }

    address public steward;
    mapping(address => bool) public validators;
    mapping(uint256 => Attestation[]) public proofs; // partyId -> attestations

    event ValidatorAdded(address indexed validator);
    event Attested(uint256 indexed partyId, address indexed attestor);

    constructor() {
        steward = msg.sender;
        validators[steward] = true;
        emit ValidatorAdded(steward);
    }

    function addValidator(address _validator) external {
        require(msg.sender == steward, "Only steward");
        validators[_validator] = true;
        emit ValidatorAdded(_validator);
    }

    function attest(uint256 _partyId, string calldata _evidenceURI) external {
        require(validators[msg.sender], "Not validator");
        proofs[_partyId].push(Attestation(_partyId, msg.sender, _evidenceURI, block.timestamp));
        emit Attested(_partyId, msg.sender);
    }

    function tally(uint256 _partyId) external view returns (uint256 count) {
        return proofs[_partyId].length;
    }
}
