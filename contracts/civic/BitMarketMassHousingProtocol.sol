// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketMassHousingProtocol {
    string public steward = "Vinvin Gueco";
    uint public targetUnits = 600_000;
    uint public unitCost = 185_000; // Example prefab cost
    uint public deployedUnits = 0;
    uint public releasedFunds = 0;

    struct HousingUnit {
        uint id;
        string barangay;
        string familyName;
        bool installed;
        bool audited;
    }

    mapping(uint => HousingUnit) public units;

    event UnitDeployed(uint id, string barangay, string familyName, uint cost);
    event AuditPassed(uint id, string barangay);

    function deployUnit(uint id, string memory barangay, string memory familyName) public {
        require(deployedUnits < targetUnits, "Target already met");
        require(units[id].installed == false, "Unit already deployed");

        units[id] = HousingUnit(id, barangay, familyName, true, false);
        deployedUnits++;
        releasedFunds += unitCost;

        emit UnitDeployed(id, barangay, familyName, unitCost);
    }

    function passAudit(uint id) public {
        require(units[id].installed == true, "Unit not yet deployed");
        require(units[id].audited == false, "Already audited");

        units[id].audited = true;
        emit AuditPassed(id, units[id].barangay);
    }

    function auditStatus() public view returns (string memory) {
        return string(abi.encodePacked(
            "Units deployed: ", uint2str(deployedUnits),
            " | Funds released: ₱", uint2str(releasedFunds),
            " | Target: 600,000 units"
        ));
    }

    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k--;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
