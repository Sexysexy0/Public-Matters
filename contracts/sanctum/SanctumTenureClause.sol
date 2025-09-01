// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumTenureClause {
    struct TenantTenure {
        string tenantID;
        string unitID;
        bool isRegistered;
        bool isEvictionProtected;
        bool isTransferable; // must remain false
        string successorID;  // family member only
        uint256 registrationTimestamp;
    }

    mapping(string => TenantTenure) public tenures;

    event TenureGranted(string tenantID, string unitID, uint256 registrationTimestamp);
    event SuccessorAssigned(string tenantID, string successorID);

    function grantTenure(string memory _tenantID, string memory _unitID) public {
        tenures[_tenantID] = TenantTenure({
            tenantID: _tenantID,
            unitID: _unitID,
            isRegistered: true,
            isEvictionProtected: true,
            isTransferable: false,
            successorID: "",
            registrationTimestamp: block.timestamp
        });

        emit TenureGranted(_tenantID, _unitID, block.timestamp);
    }

    function assignSuccessor(string memory _tenantID, string memory _successorID) public {
        require(tenures[_tenantID].isRegistered, "Tenant not registered");
        tenures[_tenantID].successorID = _successorID;

        emit SuccessorAssigned(_tenantID, _successorID);
    }

    function getTenureDetails(string memory _tenantID) public view returns (TenantTenure memory) {
        return tenures[_tenantID];
    }
}
