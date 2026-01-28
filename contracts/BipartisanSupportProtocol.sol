pragma solidity ^0.8.20;

contract BipartisanSupportProtocol {
    address public admin;

    struct Support {
        string chamber;      // e.g. Senate, House
        string parties;      // e.g. Republican + Democrat
        string effect;       // e.g. momentum, legitimacy
        uint256 timestamp;
    }

    Support[] public supports;

    event SupportLogged(string chamber, string parties, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSupport(string calldata chamber, string calldata parties, string calldata effect) external onlyAdmin {
        supports.push(Support(chamber, parties, effect, block.timestamp));
        emit SupportLogged(chamber, parties, effect, block.timestamp);
    }

    function totalSupports() external view returns (uint256) {
        return supports.length;
    }
}
