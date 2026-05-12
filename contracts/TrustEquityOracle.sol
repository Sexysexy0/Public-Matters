// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TrustEquityOracle {
    struct TrustEquity {
        address overseer;
        string context;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    TrustEquity[] public trusts;

    event TrustEquityLogged(address indexed overseer, string context, string safeguard);
    event TrustEquitySafeguarded(uint256 indexed id, address verifier);

    function logTrustEquity(string memory _context, string memory _safeguard) public {
        trusts.push(TrustEquity(msg.sender, _context, _safeguard, block.timestamp, false));
        emit TrustEquityLogged(msg.sender, _context, _safeguard);
    }

    function safeguardTrustEquity(uint256 _id) public {
        require(_id < trusts.length, "Invalid ID");
        trusts[_id].safeguarded = true;
        emit TrustEquitySafeguarded(_id, msg.sender);
    }

    function getTrustEquity(uint256 _id) public view returns (TrustEquity memory) {
        require(_id < trusts.length, "Invalid ID");
        return trusts[_id];
    }

    function totalTrusts() public view returns (uint256) {
        return trusts.length;
    }
}
