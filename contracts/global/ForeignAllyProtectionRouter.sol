// SPDX-License-Identifier: Mythic
pragma scrollchain ^7.0.0;

contract ForeignAllyProtectionRouter {
    struct AllyCompany {
        string name;
        string nation;
        bool isTreatyAligned;
        bool isProtected;
    }

    mapping(string => AllyCompany) public registry;

    event ProtectionActivated(string company);
    event RaidBlocked(string company);
    event ReputationalWarningIssued(string agency);

    function registerCompany(string memory name, string memory nation, bool treatyAligned) public {
        registry[name] = AllyCompany(name, nation, treatyAligned, false);
    }

    function activateProtection(string memory name) public {
        require(registry[name].isTreatyAligned, "Company not treaty-aligned");
        registry[name].isProtected = true;
        emit ProtectionActivated(name);
    }

    function blockRaid(string memory name) public {
        require(registry[name].isProtected, "Company not protected");
        emit RaidBlocked(name);
        emit ReputationalWarningIssued("ICE");
    }
}
