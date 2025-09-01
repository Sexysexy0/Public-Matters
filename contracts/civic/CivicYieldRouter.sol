// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CivicYieldRouter {
    address public barangayMesh;
    address public sanctumRelief;
    address public curriculumGrants;

    event YieldDistributed(uint256 totalAmount, uint256 toMesh, uint256 toRelief, uint256 toGrants);

    constructor(
        address _mesh,
        address _relief,
        address _grants
    ) {
        barangayMesh = _mesh;
        sanctumRelief = _relief;
        curriculumGrants = _grants;
    }

    function distributeYield() public payable {
        require(msg.value > 0, "No audit tax received");

        uint256 meshShare = (msg.value * 40) / 100;
        uint256 reliefShare = (msg.value * 35) / 100;
        uint256 grantsShare = msg.value - meshShare - reliefShare;

        payable(barangayMesh).transfer(meshShare);
        payable(sanctumRelief).transfer(reliefShare);
        payable(curriculumGrants).transfer(grantsShare);

        emit YieldDistributed(msg.value, meshShare, reliefShare, grantsShare);
    }
}
