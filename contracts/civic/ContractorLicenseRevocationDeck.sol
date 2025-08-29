// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract ContractorLicenseRevocationDeck {
    address public steward;

    struct Revocation {
        string contractor;
        address wallet;
        string reason;
        bool licenseRevoked;
        bool bannedFromFutureBidding;
        uint256 timestamp;
    }

    Revocation[] public revocations;

    event LicenseRevoked(string contractor, string reason);

    constructor() {
        steward = msg.sender;
    }

    function revokeLicense(
        string memory contractor,
        address wallet,
        string memory reason
    ) public {
        revocations.push(Revocation(contractor, wallet, reason, true, true, block.timestamp));
        emit LicenseRevoked(contractor, reason);
    }

    function getRevocation(uint256 index) public view returns (Revocation memory) {
        return revocations[index];
    }

    function totalRevocations() public view returns (uint256) {
        return revocations.length;
    }
}
