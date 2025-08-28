// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title BlessingLedger
/// @notice Tracks fund flows with emotional APR and civic transparency
contract BlessingLedger {
    struct Blessing {
        string purpose;
        uint256 amount;
        uint256 timestamp;
        string emotionalTag;
    }

    Blessing[] public blessings;
    address public steward;

    event BlessingLogged(string purpose, uint256 amount, string emotionalTag, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function logBlessing(string memory purpose, uint256 amount, string memory emotionalTag) public onlySteward {
        blessings.push(Blessing(purpose, amount, block.timestamp, emotionalTag));
        emit BlessingLogged(purpose, amount, emotionalTag, block.timestamp);
    }

    function getBlessing(uint256 index) public view returns (Blessing memory) {
        return blessings[index];
    }

    function totalBlessings() public view returns (uint256) {
        return blessings.length;
    }
}
