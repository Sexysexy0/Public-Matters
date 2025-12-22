// contracts/VendorProtest.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title VendorProtest
 * @notice Protocol for logging vendor protests and communal actions.
 */
contract VendorProtest {
    address public admin;

    struct Protest {
        string organizer;
        string method;   // "Noise Barrage", "March", "Petition"
        string note;
        uint256 timestamp;
    }

    Protest[] public protests;

    event ProtestLogged(string organizer, string method, string note, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logProtest(string calldata organizer, string calldata method, string calldata note) external onlyAdmin {
        protests.push(Protest(organizer, method, note, block.timestamp));
        emit ProtestLogged(organizer, method, note, block.timestamp);
    }

    function totalProtests() external view returns (uint256) { return protests.length; }

    function getProtest(uint256 id) external view returns (Protest memory) {
        require(id < protests.length, "Invalid id");
        return protests[id];
    }
}
