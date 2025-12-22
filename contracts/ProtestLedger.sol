// contracts/ProtestLedger.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ProtestLedger
 * @notice Ledger for protests and communal actions against unsafe modernization.
 */
contract ProtestLedger {
    address public admin;

    struct Protest {
        string location;
        string method;   // "Noise Barrage", "March", "Petition"
        string note;
        uint256 timestamp;
    }

    Protest[] public protests;

    event ProtestLogged(string location, string method, string note, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logProtest(string calldata location, string calldata method, string calldata note) external onlyAdmin {
        protests.push(Protest(location, method, note, block.timestamp));
        emit ProtestLogged(location, method, note, block.timestamp);
    }

    function totalProtests() external view returns (uint256) { return protests.length; }

    function getProtest(uint256 id) external view returns (Protest memory) {
        require(id < protests.length, "Invalid id");
        return protests[id];
    }
}
