// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FuelImportBlessingRouter {
    enum ImportStatus { Pending, Approved, Rejected }
    enum SourceType { Domestic, Foreign, Emergency }

    struct FuelImport {
        uint256 id;
        string originCountry;
        string portOfEntry;
        SourceType sourceType;
        uint256 volumeInBarrels;
        ImportStatus status;
        string blessingClause;
        uint256 timestamp;
    }

    mapping(uint256 => FuelImport) public importRegistry;
    uint256 public importCount;

    event ImportLogged(uint256 id, string originCountry, ImportStatus status);
    event BlessingActivated(uint256 id, string message);

    function logImport(
        string memory originCountry,
        string memory portOfEntry,
        SourceType sourceType,
        uint256 volumeInBarrels,
        ImportStatus status,
        string memory blessingClause,
        uint256 timestamp
    ) public {
        importRegistry[importCount] = FuelImport(
            importCount,
            originCountry,
            portOfEntry,
            sourceType,
            volumeInBarrels,
            status,
            blessingClause,
            timestamp
        );
        emit ImportLogged(importCount, originCountry, status);
        importCount++;
    }

    function activateBlessing(uint256 id) public returns (string memory message) {
        require(id < importCount, "Invalid import ID");
        FuelImport memory imp = importRegistry[id];

        if (imp.status == ImportStatus.Approved) {
            emit BlessingActivated(id, "Fuel import approved – corridor activated");
            return "Fuel import approved – corridor activated";
        } else if (imp.status == ImportStatus.Rejected) {
            emit BlessingActivated(id, "Fuel import rejected – corridor sealed");
            return "Fuel import rejected – corridor sealed";
        } else {
            emit BlessingActivated(id, "Fuel import pending – ceremonial review required");
            return "Fuel import pending – ceremonial review required";
        }
    }

    function getImport(uint256 id) public view returns (FuelImport memory) {
        return importRegistry[id];
    }
}
