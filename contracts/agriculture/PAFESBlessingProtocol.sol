// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title PAFESBlessingProtocol
/// @dev Tracks provincial extension performance, emotional APR, and damay clause triggers

contract PAFESBlessingProtocol {
    address public steward;
    mapping(address => uint256) public blessingScore;
    mapping(address => string) public emotionalAPR;
    mapping(address => bool) public damayTriggered;

    event BlessingLogged(address indexed province, uint256 score, string apr);
    event DamayActivated(address indexed province, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logBlessing(address province, uint256 score, string memory apr) public onlySteward {
        blessingScore[province] = score;
        emotionalAPR[province] = apr;
        emit BlessingLogged(province, score, apr);

        if (score < 50 || keccak256(bytes(apr)) == keccak256(bytes("Grief"))) {
            damayTriggered[province] = true;
            emit DamayActivated(province, "Low blessing score or grief APR detected");
        }
    }

    function getBlessingStatus(address province) public view returns (uint256, string memory, bool) {
        return (
            blessingScore[province],
            emotionalAPR[province],
            damayTriggered[province]
        );
    }
}
