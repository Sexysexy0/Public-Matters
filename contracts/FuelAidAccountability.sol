// FuelAidAccountability.sol
pragma solidity ^0.8.0;

contract FuelAidAccountability {
    struct AuditTrail {
        bytes32 batchHash;      // Hash of distribution list
        string fuelProvider;    // Name of gas station/provider
        uint256 totalLiterCap;
        uint256 timestamp;
    }

    mapping(uint256 => AuditTrail) public auditLogs;
    uint256 public logCount;

    function logFuelDistribution(bytes32 _hash, string memory _provider, uint256 _cap) public {
        logCount++;
        auditLogs[logCount] = AuditTrail(_hash, _provider, _cap, block.timestamp);
    }

    function verifyIntegrity(uint256 _id, bytes32 _checkHash) public view returns (bool) {
        return auditLogs[_id].batchHash == _checkHash;
    }
}
