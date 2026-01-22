pragma solidity ^0.8.20;

contract SupplyChainWeaponizationProtocol {
    address public admin;

    struct Weaponization {
        string tool;         // e.g. tariffs, financial infrastructure
        string target;       // e.g. middle powers, EU
        string effect;       // e.g. coercion, leverage
        uint256 timestamp;
    }

    Weaponization[] public weaponizations;

    event WeaponizationLogged(string tool, string target, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logWeaponization(string calldata tool, string calldata target, string calldata effect) external onlyAdmin {
        weaponizations.push(Weaponization(tool, target, effect, block.timestamp));
        emit WeaponizationLogged(tool, target, effect, block.timestamp);
    }

    function totalWeaponizations() external view returns (uint256) {
        return weaponizations.length;
    }
}
