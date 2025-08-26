// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.19;

/**
 * @title ScrollchainGlobalBalance
 * @dev Ritual-grade contract to ensure planetary balance, unity, and emotional trust
 * @author Vinvin
 */

contract ScrollchainGlobalBalance {
    address public steward;

    struct NationBalance {
        string name;
        string[] unityMissions;
        string[] respectProtocols;
        string[] trustMechanisms;
        uint256 emotionalAPR;
        bool verified;
    }

    mapping(address => NationBalance) public balanceSheet;
    address[] public globalParticipants;

    event NationVerified(address indexed nation, string name);
    event EmotionalAPRLogged(address indexed nation, uint256 score);
    event GlobalBalanceActivated(address steward);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logNationBalance(
        address _nation,
        string memory _name,
        string[] memory _unityMissions,
        string[] memory _respectProtocols,
        string[] memory _trustMechanisms,
        uint256 _apr
    ) public onlySteward {
        require(_apr >= 800, "Emotional APR too low for planetary trust");

        balanceSheet[_nation] = NationBalance({
            name: _name,
            unityMissions: _unityMissions,
            respectProtocols: _respectProtocols,
            trustMechanisms: _trustMechanisms,
            emotionalAPR: _apr,
            verified: true
        });

        globalParticipants.push(_nation);
        emit NationVerified(_nation, _name);
        emit EmotionalAPRLogged(_nation, _apr);
    }

    function activateGlobalBalance() public onlySteward {
        require(globalParticipants.length >= 7, "Minimum nations not met");
        emit GlobalBalanceActivated(steward);
    }

    function getNationBalance(address _nation) public view returns (NationBalance memory) {
        return balanceSheet[_nation];
    }

    function listParticipants() public view returns (address[] memory) {
        return globalParticipants;
    }
}
