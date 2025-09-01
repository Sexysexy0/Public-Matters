// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract NoLicenseNoEntry {
    struct Contractor {
        string name;
        string licenseNumber;
        bool hasBorrowedLicense;
        bool isVerified;
        uint256 timestamp;
    }

    mapping(address => Contractor) public contractors;

    event ContractorLogged(
        address indexed contractorAddress,
        string name,
        string licenseNumber,
        bool hasBorrowedLicense,
        bool isVerified,
        uint256 timestamp
    );

    function logContractor(
        address contractorAddress,
        string memory name,
        string memory licenseNumber,
        bool hasBorrowedLicense,
        bool isVerified
    ) public {
        require(!hasBorrowedLicense, "Borrowed license not accepted.");
        contractors[contractorAddress] = Contractor(
            name,
            licenseNumber,
            hasBorrowedLicense,
            isVerified,
            block.timestamp
        );

        emit ContractorLogged(
            contractorAddress,
            name,
            licenseNumber,
            hasBorrowedLicense,
            isVerified,
            block.timestamp
        );
    }

    function getContractor(address contractorAddress) public view returns (Contractor memory) {
        return contractors[contractorAddress];
    }
}
