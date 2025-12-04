// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToRenewableEquityGrid {
    string public batchID = "1321.9.252";
    string public steward = "Vinvin";

    address public admin;

    struct Renewable {
        string source;     // solar, wind, hydro, geothermal
        string status;     // equitable, pending, ghost
        uint256 timestamp;
    }

    Renewable[] public sources;

    event RenewableLogged(string source, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logSource(string memory source, string memory status) public onlyAdmin {
        sources.push(Renewable(source, status, block.timestamp));
        emit RenewableLogged(source, status);
    }

    function getSource(uint256 index) public view returns (string memory source, string memory status, uint256 timestamp) {
        Renewable memory r = sources[index];
        return (r.source, r.status, r.timestamp);
    }
}
