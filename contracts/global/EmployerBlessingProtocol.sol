// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title EmployerBlessingProtocol
/// @dev Certifies employers with emotional APR, damay clause, and scrollchain verification. Includes indexed lookup and audit logs.

contract EmployerBlessingProtocol {
    struct Employer {
        string name;
        uint8 emotionalAPR; // 1–10 scale
        bool damayClauseCompliant;
        bool scrollchainVerified;
        string blessingTag;
        uint256 timestamp;
    }

    Employer[] public certifiedEmployers;
    mapping(address => Employer) public employerRegistry;
    mapping(address => bool) public isCertified;

    event EmployerCertified(
        address indexed employerAddress,
        string name,
        uint8 emotionalAPR,
        bool damayClauseCompliant,
        bool scrollchainVerified,
        string blessingTag,
        uint256 timestamp
    );

    event EmployerRevoked(address indexed employerAddress, string name, uint256 timestamp);

    modifier validBlessing(uint8 _emotionalAPR, bool _damayClauseCompliant) {
        require(_emotionalAPR >= 7, "Emotional APR too low");
        require(_damayClauseCompliant, "Damay clause not honored");
        _;
    }

    function certifyEmployer(
        address _employerAddress,
        string memory _name,
        uint8 _emotionalAPR,
        bool _damayClauseCompliant,
        bool _scrollchainVerified,
        string memory _blessingTag
    ) public validBlessing(_emotionalAPR, _damayClauseCompliant) {
        require(!isCertified[_employerAddress], "Already certified");

        Employer memory newEmployer = Employer({
            name: _name,
            emotionalAPR: _emotionalAPR,
            damayClauseCompliant: _damayClauseCompliant,
            scrollchainVerified: _scrollchainVerified,
            blessingTag: _blessingTag,
            timestamp: block.timestamp
        });

        certifiedEmployers.push(newEmployer);
        employerRegistry[_employerAddress] = newEmployer;
        isCertified[_employerAddress] = true;

        emit EmployerCertified(
            _employerAddress,
            _name,
            _emotionalAPR,
            _damayClauseCompliant,
            _scrollchainVerified,
            _blessingTag,
            block.timestamp
        );
    }

    function revokeEmployer(address _employerAddress) public {
        require(isCertified[_employerAddress], "Employer not certified");
        string memory name = employerRegistry[_employerAddress].name;

        delete employerRegistry[_employerAddress];
        isCertified[_employerAddress] = false;

        emit EmployerRevoked(_employerAddress, name, block.timestamp);
    }

    function getEmployerByAddress(address _employerAddress) public view returns (Employer memory) {
        require(isCertified[_employerAddress], "Employer not certified");
        return employerRegistry[_employerAddress];
    }

    function totalCertified() public view returns (uint256) {
        return certifiedEmployers.length;
    }
}
