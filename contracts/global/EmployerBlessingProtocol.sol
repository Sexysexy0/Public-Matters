// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EmployerBlessingProtocol {
    struct Employer {
        string name;
        uint8 emotionalAPR; // 1–10 scale
        bool damayClauseCompliant;
        bool scrollchainVerified;
        string blessingTag; // e.g., "Kinder Queen Ally", "Civic Steward", "Planetary Employer"
        uint256 timestamp;
    }

    Employer[] public certifiedEmployers;

    event EmployerCertified(
        string name,
        uint8 emotionalAPR,
        bool damayClauseCompliant,
        bool scrollchainVerified,
        string blessingTag,
        uint256 timestamp
    );

    function certifyEmployer(
        string memory _name,
        uint8 _emotionalAPR,
        bool _damayClauseCompliant,
        bool _scrollchainVerified,
        string memory _blessingTag
    ) public {
        certifiedEmployers.push(Employer(
            _name,
            _emotionalAPR,
            _damayClauseCompliant,
            _scrollchainVerified,
            _blessingTag,
            block.timestamp
        ));
        emit EmployerCertified(_name, _emotionalAPR, _damayClauseCompliant, _scrollchainVerified, _blessingTag, block.timestamp);
    }

    function getEmployer(uint256 index) public view returns (Employer memory) {
        require(index < certifiedEmployers.length, "Invalid index");
        return certifiedEmployers[index];
    }

    function totalCertified() public view returns (uint256) {
        return certifiedEmployers.length;
    }
}
