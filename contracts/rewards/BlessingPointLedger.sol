// SPDX-License-Identifier: BlessingPoint-License  
pragma solidity ^0.8.19;

contract BlessingPointLedger {
    mapping(address => uint) public blessingPoints;

    event BlessingPointEarned(address steward, uint points);
    event BlessingPointRedeemed(address steward, uint points);

    function earnPoints(address steward, uint points) public {
        blessingPoints[steward] += points;
        emit BlessingPointEarned(steward, points);
    }

    function redeemPoints(address steward, uint points) public {
        require(blessingPoints[steward] >= points, "Not enough points");
        blessingPoints[steward] -= points;
        emit BlessingPointRedeemed(steward, points);
    }

    function getPoints(address steward) public view returns (uint) {
        return blessingPoints[steward];
    }
}
