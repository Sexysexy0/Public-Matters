// SPDX-License-Identifier: EnergySanctum
pragma solidity ^0.8.19;

contract EnergyMixPermitRouter {
    address public steward;

    struct Permit {
        string applicant;
        string energySources;
        string purpose;
        uint256 capacityMW;
        uint256 timestamp;
        bool verified;
    }

    Permit[] public permits;

    event PermitLogged(string applicant, string energySources, uint256 capacityMW, uint256 timestamp);
    event PermitVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logPermit(
        string memory applicant,
        string memory energySources,
        string memory purpose,
        uint256 capacityMW
    ) public {
        permits.push(Permit(applicant, energySources, purpose, capacityMW, block.timestamp, false));
        emit PermitLogged(applicant, energySources, capacityMW, block.timestamp);
    }

    function verifyPermit(uint256 index) public {
        require(index < permits.length, "Invalid index");
        permits[index].verified = true;
        emit PermitVerified(index, msg.sender);
    }

    function getPermit(uint256 index) public view returns (
        string memory, string memory, string memory, uint256, uint256, bool
    ) {
        Permit memory p = permits[index];
        return (p.applicant, p.energySources, p.purpose, p.capacityMW, p.timestamp, p.verified);
    }

    function totalPermits() public view returns (uint256) {
        return permits.length;
    }
}
