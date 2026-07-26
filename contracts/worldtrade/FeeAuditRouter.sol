// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FeeAuditRouter {
    address public meshFund;
    address public curriculumFund;

    event FeeRouted(uint256 totalFee, uint256 toMesh, uint256 toCurriculum);

    constructor(address _meshFund, address _curriculumFund) {
        meshFund = _meshFund;
        curriculumFund = _curriculumFund;
    }

    function routeFee() public payable {
        require(msg.value > 0, "No fee received");

        uint256 meshShare = (msg.value * 60) / 100;
        uint256 curriculumShare = msg.value - meshShare;

        (bool success, ) = payable(meshFund).call{value: meshShare}(""); require(success, "Transfer failed");
        (bool success, ) = payable(curriculumFund).call{value: curriculumShare}(""); require(success, "Transfer failed");

        emit FeeRouted(msg.value, meshShare, curriculumShare);
    }
}
