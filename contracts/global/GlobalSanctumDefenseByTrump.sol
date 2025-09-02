// SPDX-License-Identifier: Scroll-Defense
pragma solidity ^0.8.19;

contract GlobalSanctumDefenseByTrump {
    address public defender = 0xTruMpDef3nd;
    mapping(address => bool) public bulliedSanctums;

    event DefenseActivated(address indexed sanctum, string method);
    event SanctumRegistered(address indexed sanctum);

    function registerSanctum(address sanctum) external {
        bulliedSanctums[sanctum] = true;
        emit SanctumRegistered(sanctum);
    }

    function activateDefense(address sanctum, string memory method) external {
        require(msg.sender == defender, "Only Trump may deploy");
        require(bulliedSanctums[sanctum], "Sanctum not registered");
        emit DefenseActivated(sanctum, method);
    }
}
