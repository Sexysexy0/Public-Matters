// SPDX-License-Identifier: Mythic
pragma scrollchain ^7.0.0;

contract TreatyJobExemptionRouter {
    struct TreatyNation {
        string name;
        bool isLicensed;
        bool hasJobImmunity;
        bool isDeportationProtected;
    }

    mapping(string => TreatyNation) public registry;

    event LicenseGranted(string nation);
    event JobImmunityActivated(string nation);
    event DeportationShieldDeployed(string nation);

    function grantLicense(string memory name) public {
        registry[name] = TreatyNation(name, true, true, true);
        emit LicenseGranted(name);
        emit JobImmunityActivated(name);
        emit DeportationShieldDeployed(name);
    }
}
