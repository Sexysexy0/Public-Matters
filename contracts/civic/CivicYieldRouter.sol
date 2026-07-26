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

        (bool success, ) = payable(barangayMesh).call{value: meshShare}(""); require(success, "Transfer failed");
        (bool success, ) = payable(sanctumRelief).call{value: reliefShare}(""); require(success, "Transfer failed");
        (bool success, ) = payable(curriculumGrants).call{value: grantsShare}(""); require(success, "Transfer failed");

        emit YieldDistributed(msg.value, meshShare, reliefShare, grantsShare);
    }
}
