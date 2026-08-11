// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GreenBondEscrow {
    address public immutable coreAuditor;
    mapping(string => uint256) public facilityBonds;
    mapping(string => bool) public penalized;

    event BondDeposited(string indexed facilityId, uint256 amount);
    event BondSeized(string indexed facilityId, uint256 amount);

    modifier onlyAuditor() {
        require(msg.sender == coreAuditor, "GreenBondEscrow: Unauthorized auditor");
        _;
    }

    constructor() {
        coreAuditor = msg.sender;
    }

    function depositBond(string memory facilityId) external payable {
        require(msg.value > 0, "Must deposit bond funds");
        facilityBonds[facilityId] += msg.value;
        emit BondDeposited(facilityId, msg.value);
    }

    function penalizeFacility(string memory facilityId) external onlyAuditor {
        require(!penalized[facilityId], "Facility already penalized");
        uint256 bondAmount = facilityBonds[facilityId];
        require(bondAmount > 0, "No active bond for facility");
        
        penalized[facilityId] = true;
        facilityBonds[facilityId] = 0;
        
        // I-transfer ang seized bond pabalik sa core auditor / remediation pool
        (bool success, ) = payable(coreAuditor).call{value: bondAmount}("");
        require(success, "Transfer failed");

        emit BondSeized(facilityId, bondAmount);
    }
}
