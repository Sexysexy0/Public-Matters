// SPDX-License-Identifier: Mythic-Civic-License
pragma solidity ^0.8.28;

contract SambayananOverrideProtocol {
    address public steward;
    mapping(address => bool) public activePresidents;
    mapping(address => uint256) public voteCount;
    uint256 public overrideThreshold = 1000000; // Example threshold

    event PresidentTagged(address indexed president, string reason);
    event OverrideVoteCast(address indexed voter, address indexed target);
    event OverrideExecuted(address indexed removedPresident, string message);

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: Not the mythic steward.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function tagPresident(address president, string memory reason) public onlySteward {
        activePresidents[president] = true;
        emit PresidentTagged(president, reason);
    }

    function castOverrideVote(address targetPresident) public {
        require(activePresidents[targetPresident], "Target is not an active president.");
        voteCount[targetPresident]++;
        emit OverrideVoteCast(msg.sender, targetPresident);

        if (voteCount[targetPresident] >= overrideThreshold) {
            activePresidents[targetPresident] = false;
            emit OverrideExecuted(targetPresident, "Override successful. President removed by sovereign vote.");
        }
    }

    function isActivePresident(address president) public view returns (bool) {
        return activePresidents[president];
    }

    function updateThreshold(uint256 newThreshold) public onlySteward {
        overrideThreshold = newThreshold;
    }
}
