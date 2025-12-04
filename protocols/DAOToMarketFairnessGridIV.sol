// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToMarketFairnessGridIV {
    string public batchID = "1321.9.258";
    string public steward = "Vinvin";

    address public admin;

    struct Market {
        string sector;     // retail, energy, transport, food
        string status;     // fair, pending, ghost
        uint256 timestamp;
    }

    Market[] public markets;

    event MarketLogged(string sector, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logMarket(string memory sector, string memory status) public onlyAdmin {
        markets.push(Market(sector, status, block.timestamp));
        emit MarketLogged(sector, status);
    }

    function getMarket(uint256 index) public view returns (string memory sector, string memory status, uint256 timestamp) {
        Market memory m = markets[index];
        return (m.sector, m.status, m.timestamp);
    }
}
