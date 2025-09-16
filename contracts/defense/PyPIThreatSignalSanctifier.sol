// SPDX-License-Identifier: PyPISanctum
pragma solidity ^0.8.19;

contract PyPIThreatSignalSanctifier {
    struct PackageSignal {
        string packageName;
        string authorAlias;
        bool flagged;
        string stewardNote;
    }

    mapping(string => PackageSignal) public packageRegistry;

    event PackageTagged(string packageName, string authorAlias);
    event PackageSanctified(string packageName);

    function tagPackage(string memory packageName, string memory authorAlias, string memory stewardNote) public {
        packageRegistry[packageName] = PackageSignal(packageName, authorAlias, false, stewardNote);
        emit PackageTagged(packageName, authorAlias);
    }

    function sanctifyPackage(string memory packageName) public {
        require(bytes(packageRegistry[packageName].authorAlias).length > 0, "Package not tagged");
        packageRegistry[packageName].flagged = true;
        emit PackageSanctified(packageName);
    }

    function getPackageStatus(string memory packageName) public view returns (PackageSignal memory) {
        return packageRegistry[packageName];
    }
}
