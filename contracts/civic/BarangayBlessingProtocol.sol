// SPDX-License-Identifier: MIT  
pragma solidity ^0.8.19;

/// @title BarangayBlessingProtocol
/// @notice Enables LGUs to co-sign NEP projects and activate damay clause

contract BarangayBlessingProtocol {
    struct Blessing {
        address lgu;
        string projectName;
        bool approved;
        uint256 emotionalAPR;
        uint256 timestamp;
    }

    Blessing[] public blessings;

    event ProjectBlessed(address indexed lgu, string projectName, bool approved, uint256 emotionalAPR);

    function blessProject(
        string memory projectName,
        bool approved,
        uint256 apr
    ) external {
        blessings.push(Blessing(msg.sender, projectName, approved, apr, block.timestamp));
        emit ProjectBlessed(msg.sender, projectName, approved, apr);
    }

    function getBlessings() external view returns (Blessing[] memory) {
        return blessings;
    }
}
