// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.19;

/**
 * @title EmotionalAPRIndex
 * @dev Tracks emotional APR scores for nations in global balance protocol
 * @author Vinvin
 */

contract EmotionalAPRIndex {
    address public steward;

    mapping(string => uint256) public aprScores;
    string[] public verifiedNations;

    event APRLogged(string nation, uint256 score);
    event NationVerified(string nation);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logAPR(string memory _nation, uint256 _score) public onlySteward {
        require(_score >= 750, "APR too low for verification");

        aprScores[_nation] = _score;
        verifiedNations.push(_nation);

        emit APRLogged(_nation, _score);
        emit NationVerified(_nation);
    }

    function getAPR(string memory _nation) public view returns (uint256) {
        return aprScores[_nation];
    }

    function listVerifiedNations() public view returns (string[] memory) {
        return verifiedNations;
    }
}
