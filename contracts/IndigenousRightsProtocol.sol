pragma solidity ^0.8.20;

contract IndigenousRightsProtocol {
    address public admin;

    struct Rights {
        string community;    // e.g. Indigenous Peoples of Dupax
        string principle;    // e.g. Free, Prior, Informed Consent (FPIC)
        string violation;    // e.g. deceptive attendance sheets
        uint256 timestamp;
    }

    Rights[] public rights;

    event RightsLogged(string community, string principle, string violation, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRights(string calldata community, string calldata principle, string calldata violation) external onlyAdmin {
        rights.push(Rights(community, principle, violation, block.timestamp));
        emit RightsLogged(community, principle, violation, block.timestamp);
    }

    function totalRights() external view returns (uint256) {
        return rights.length;
    }
}
