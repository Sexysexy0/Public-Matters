// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PublicOfficeIntegrityScore {
    mapping(address => uint256) public integrityPoints;

    // Edu: "Refuse to reward failure" [2:08]
    function updateIntegrity(address _leader, bool _deliveredPromise) public {
        if (_deliveredPromise) {
            integrityPoints[_leader] += 10;
        } else {
            integrityPoints[_leader] = 0; // Back to zero for failure to deliver
        }
    }
}
