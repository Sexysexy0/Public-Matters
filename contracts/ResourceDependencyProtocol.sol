pragma solidity ^0.8.20;

contract ResourceDependencyProtocol {
    address public admin;

    struct Resource {
        string material;     // e.g. antimony, gallium, germanium
        string controller;   // e.g. China
        string impact;       // e.g. military vulnerability, semiconductor fragility
        uint256 timestamp;
    }

    Resource[] public resources;

    event ResourceLogged(string material, string controller, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResource(string calldata material, string calldata controller, string calldata impact) external onlyAdmin {
        resources.push(Resource(material, controller, impact, block.timestamp));
        emit ResourceLogged(material, controller, impact, block.timestamp);
    }

    function totalResources() external view returns (uint256) {
        return resources.length;
    }
}
