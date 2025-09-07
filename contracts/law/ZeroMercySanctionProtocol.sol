// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract ZeroMercySanctionProtocol {
    string public steward = "Vinvin Gueco";
    uint public sentenceYears = 10;
    bool public bailAllowed = false;
    bool public assetFreezeActive = true;

    struct Offender {
        string name;
        string role;
        bool convicted;
    }

    mapping(string => Offender) public offenders;

    event SanctionDeployed(string name, string role, uint sentenceYears, bool bailStatus, bool assetsFrozen);

    function sanctionOffender(string memory name, string memory role) public {
        offenders[name] = Offender(name, role, true);
        emit SanctionDeployed(name, role, sentenceYears, bailAllowed, assetFreezeActive);
    }

    function auditOffender(string memory name) public view returns (string memory) {
        if (offenders[name].convicted) {
            return string(abi.encodePacked(name, " sanctioned for 10 years, no bail, assets frozen."));
        } else {
            return string(abi.encodePacked(name, " not yet sanctioned. Scrollchain audit pending."));
        }
    }
}
