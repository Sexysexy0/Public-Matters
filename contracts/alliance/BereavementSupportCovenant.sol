// SPDX-License-Identifier: BereavementSupport-License
pragma solidity ^0.8.0;

contract BereavementSupportCovenant {
    address public steward;

    struct SupportPackage {
        string beneficiary;
        uint256 cashRelief;
        string jobPlacementTrack;
        string emotionalAPRProgram;
        bool verified;
        uint256 timestamp;
    }

    SupportPackage[] public packages;

    event SupportPackageIssued(string beneficiary, uint256 cashRelief, string jobTrack, string aprProgram, bool verified, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function issuePackage(string memory beneficiary, uint256 cashRelief, string memory jobPlacementTrack, string memory emotionalAPRProgram, bool verified) public {
        require(msg.sender == steward, "Only steward can issue");
        packages.push(SupportPackage(beneficiary, cashRelief, jobPlacementTrack, emotionalAPRProgram, verified, block.timestamp));
        emit SupportPackageIssued(beneficiary, cashRelief, jobPlacementTrack, emotionalAPRProgram, verified, block.timestamp);
    }

    function getPackage(uint index) public view returns (string memory, uint256, string memory, string memory, bool, uint256) {
        SupportPackage memory p = packages[index];
        return (p.beneficiary, p.cashRelief, p.jobPlacementTrack, p.emotionalAPRProgram, p.verified, p.timestamp);
    }
}
