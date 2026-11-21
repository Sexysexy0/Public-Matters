// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/OperatorPrivileges.sol";
import "./AccessControlGovernance.sol";

contract GTACharacterRegistry {
    struct Character {
        string name;
        uint256 level;
        uint256 xp;
        uint256 cash;
        uint256 wantedLevel;
        bool active;
        uint256 createdAt;
    }

    OperatorPrivileges public immutable privileges;
    AccessControlGovernance public immutable governance;

    mapping(address => Character) public characters;
    mapping(address => bool) public hasCharacter;

    uint256 public constant MAX_WANTED_LEVEL = 5;
    uint256 public constant XP_PER_LEVEL = 100;

    event CharacterCreated(address indexed player, string name, uint256 timestamp);
    event LevelUp(address indexed player, uint256 newLevel, uint256 newXp);
    event CashUpdated(address indexed player, uint256 newCash);
    event WantedLevelUpdated(address indexed player, uint256 newWantedLevel);
    event CharacterDeactivated(address indexed player);

    error NotOperator();
    error AlreadyHasCharacter();
    error NoCharacter();
    error InvalidWantedLevel();
    error CharacterInactive();

    modifier onlyOperator() {
        if (!privileges.isOperator(msg.sender)) revert NotOperator();
        _;
    }

    modifier onlyActiveCharacter(address _player) {
        if (!hasCharacter[_player]) revert NoCharacter();
        if (!characters[_player].active) revert CharacterInactive();
        _;
    }

    constructor(address _privileges, address _governance) {
        require(_privileges != address(0), "privileges=0");
        require(_governance != address(0), "governance=0");
        privileges = OperatorPrivileges(_privileges);
        governance = AccessControlGovernance(_governance);
    }

    function createCharacter(string calldata _name) external {
        if (hasCharacter[msg.sender]) revert AlreadyHasCharacter();
        characters[msg.sender] = Character({
            name: _name,
            level: 1,
            xp: 0,
            cash: 0,
            wantedLevel: 0,
            active: true,
            createdAt: block.timestamp
        });
        hasCharacter[msg.sender] = true;
        emit CharacterCreated(msg.sender, _name, block.timestamp);
    }

    function addXp(address _player, uint256 _xp) external onlyOperator onlyActiveCharacter(_player) {
        Character storage c = characters[_player];
        c.xp += _xp;
        while (c.xp >= XP_PER_LEVEL) {
            c.xp -= XP_PER_LEVEL;
            c.level++;
        }
        emit LevelUp(_player, c.level, c.xp);
    }

    function updateCash(address _player, int256 _delta) external onlyOperator onlyActiveCharacter(_player) {
        Character storage c = characters[_player];
        if (_delta >= 0) {
            c.cash += uint256(_delta);
        } else {
            uint256 abs = uint256(-_delta);
            require(c.cash >= abs, "insufficient cash");
            c.cash -= abs;
        }
        emit CashUpdated(_player, c.cash);
    }

    function setWantedLevel(address _player, uint256 _level) external onlyOperator onlyActiveCharacter(_player) {
        if (_level > MAX_WANTED_LEVEL) revert InvalidWantedLevel();
        characters[_player].wantedLevel = _level;
        emit WantedLevelUpdated(_player, _level);
    }

    function deactivateCharacter(address _player) external onlyOperator onlyActiveCharacter(_player) {
        characters[_player].active = false;
        emit CharacterDeactivated(_player);
    }

    function getCharacter(address _player) external view returns (
        string memory name,
        uint256 level,
        uint256 xp,
        uint256 cash,
        uint256 wantedLevel,
        bool active
    ) {
        Character memory c = characters[_player];
        return (c.name, c.level, c.xp, c.cash, c.wantedLevel, c.active);
    }
}
