// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.19;

/**
 * @title EmotionalAPROverride
 * @dev Allows high-trust importers to bypass tariff penalties
 * @author Vinvin
 */

contract EmotionalAPROverride {
    address public steward;
    uint256 public overrideThreshold = 900;

    mapping(string => uint256) public importerAPR;
    mapping(string => bool) public overrideStatus;

    event APRLogged(string importer, uint256 score);
    event OverrideActivated(string importer);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logAPR(string memory _importer, uint256 _score) public onlySteward {
        importerAPR[_importer] = _score;

        if (_score >= overrideThreshold) {
            overrideStatus[_importer] = true;
            emit OverrideActivated(_importer);
        }

        emit APRLogged(_importer, _score);
    }

    function isOverrideActive(string memory _importer) public view returns (bool) {
        return overrideStatus[_importer];
    }
}
