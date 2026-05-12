// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FranchiseContinuityVault {
    struct FranchisePath {
        address actor;
        string franchise;
        string role;
        uint256 timestamp;
        bool safeguarded;
    }

    FranchisePath[] public paths;

    event FranchiseLogged(address indexed actor, string franchise, string role);
    event FranchiseSafeguarded(uint256 indexed id, address verifier);

    function logFranchise(string memory _franchise, string memory _role) public {
        paths.push(FranchisePath(msg.sender, _franchise, _role, block.timestamp, false));
        emit FranchiseLogged(msg.sender, _franchise, _role);
    }

    function safeguardFranchise(uint256 _id) public {
        require(_id < paths.length, "Invalid ID");
        paths[_id].safeguarded = true;
        emit FranchiseSafeguarded(_id, msg.sender);
    }

    function getFranchise(uint256 _id) public view returns (FranchisePath memory) {
        require(_id < paths.length, "Invalid ID");
        return paths[_id];
    }

    function totalFranchises() public view returns (uint256) {
        return paths.length;
    }
}
