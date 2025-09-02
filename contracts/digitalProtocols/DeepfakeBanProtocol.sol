// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DeepfakeBanProtocol {
    struct AppAudit {
        string appName;
        string developer;
        bool usesDeepfakeTech;
        bool nudifierDetected;
        bool impersonationRisk;
        uint8 emotionalAPR; // 1–10 scale
        bool banned;
        uint256 timestamp;
    }

    AppAudit[] public audits;

    event AppBanned(
        string appName,
        string developer,
        bool nudifierDetected,
        bool impersonationRisk,
        uint8 emotionalAPR,
        uint256 timestamp
    );

    function auditApp(
        string memory _appName,
        string memory _developer,
        bool _usesDeepfakeTech,
        bool _nudifierDetected,
        bool _impersonationRisk,
        uint8 _emotionalAPR
    ) public {
        bool shouldBan = _usesDeepfakeTech && (_nudifierDetected || _impersonationRisk || _emotionalAPR < 5);
        audits.push(AppAudit(
            _appName,
            _developer,
            _usesDeepfakeTech,
            _nudifierDetected,
            _impersonationRisk,
            _emotionalAPR,
            shouldBan,
            block.timestamp
        ));

        if (shouldBan) {
            emit AppBanned(_appName, _developer, _nudifierDetected, _impersonationRisk, _emotionalAPR, block.timestamp);
        }
    }

    function getAudit(uint256 index) public view returns (AppAudit memory) {
        require(index < audits.length, "Invalid index");
        return audits[index];
    }

    function totalAudits() public view returns (uint256) {
        return audits.length;
    }

    function totalBanned() public view returns (uint256 count) {
        for (uint256 i = 0; i < audits.length; i++) {
            if (audits[i].banned) {
                count++;
            }
        }
    }
}
