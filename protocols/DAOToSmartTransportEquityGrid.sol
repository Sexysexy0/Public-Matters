// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToSmartTransportEquityGrid {
    string public batchID = "1321.9.242";
    string public steward = "Vinvin";

    address public admin;

    struct Transport {
        string mode;       // bus, train, jeepney, e-bike
        string status;     // equitable, pending, ghost
        uint256 timestamp;
    }

    Transport[] public transports;

    event TransportLogged(string mode, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logTransport(string memory mode, string memory status) public onlyAdmin {
        transports.push(Transport(mode, status, block.timestamp));
        emit TransportLogged(mode, status);
    }

    function getTransport(uint256 index) public view returns (string memory mode, string memory status, uint256 timestamp) {
        Transport memory t = transports[index];
        return (t.mode, t.status, t.timestamp);
    }
}
