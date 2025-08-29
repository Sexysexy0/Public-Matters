// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract DpwhPurgeProtocol {
    address public steward;

    struct Contractor {
        string name;
        address wallet;
        bool revoked;
        bool emotionallyTagged;
        bool publiclyDisclosed;
    }

    mapping(address => Contractor) public contractors;
    address[] public revokedList;

    event LicenseRevoked(address indexed wallet, string name);
    event ReenrollmentRequested(address indexed wallet, string name);
    event PublicDisclosureLogged(string name, string project, uint256 budget, string location);

    constructor() {
        steward = msg.sender;
    }

    function revokeLicense(address wallet, string memory name) public {
        require(msg.sender == steward, "Only steward may purge");
        contractors[wallet] = Contractor(name, wallet, true, false, false);
        revokedList.push(wallet);
        emit LicenseRevoked(wallet, name);
    }

    function requestReenrollment(address wallet, string memory name) public {
        require(contractors[wallet].revoked, "Not previously revoked");
        emit ReenrollmentRequested(wallet, name);
    }

    function logPublicDisclosure(string memory name, string memory project, uint256 budget, string memory location) public {
        emit PublicDisclosureLogged(name, project, budget, location);
    }

    function getRevokedList() public view returns (address[] memory) {
        return revokedList;
    }
}
