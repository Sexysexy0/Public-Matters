// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract ContractorBlessingProtocol {
    struct Contractor {
        string name;
        string licenseNumber;
        string barangayEndorsement;
        string emotionalAPRTag;
        bool isBlessed;
        uint256 timestamp;
    }

    mapping(address => Contractor) public blessedContractors;

    event ContractorBlessed(
        address indexed contractorAddress,
        string name,
        string licenseNumber,
        string barangayEndorsement,
        string emotionalAPRTag,
        bool isBlessed,
        uint256 timestamp
    );

    function blessContractor(
        address contractorAddress,
        string memory name,
        string memory licenseNumber,
        string memory barangayEndorsement,
        string memory emotionalAPRTag
    ) public {
        blessedContractors[contractorAddress] = Contractor(
            name,
            licenseNumber,
            barangayEndorsement,
            emotionalAPRTag,
            true,
            block.timestamp
        );

        emit ContractorBlessed(
            contractorAddress,
            name,
            licenseNumber,
            barangayEndorsement,
            emotionalAPRTag,
            true,
            block.timestamp
        );
    }

    function getBlessedContractor(address contractorAddress) public view returns (Contractor memory) {
        return blessedContractors[contractorAddress];
    }
}
