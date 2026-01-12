pragma solidity ^0.8.20;

contract PortReviewProtocol {
    address public admin;

    struct PortDeal {
        string port;         // e.g. Tehran, Bandar Abbas, communal docks
        string status;       // e.g. fair, unfair, under review
        uint256 timestamp;
    }

    PortDeal[] public portDeals;

    event PortDealLogged(string port, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPortDeal(string calldata port, string calldata status) external onlyAdmin {
        portDeals.push(PortDeal(port, status, block.timestamp));
        emit PortDealLogged(port, status, block.timestamp);
    }

    function totalPortDeals() external view returns (uint256) {
        return portDeals.length;
    }
}
