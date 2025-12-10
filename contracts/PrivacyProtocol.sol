// contracts/PrivacyProtocol.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PrivacyProtocol
 * @notice Validator-grade privacy and communal control of sensitive data.
 */
contract PrivacyProtocol {
    address public admin;

    struct PrivacySeal {
        string dataTag;
        bool encrypted;
        string note;
        uint256 timestamp;
    }

    PrivacySeal[] public seals;

    event PrivacyLogged(string dataTag, bool encrypted, string note, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logPrivacy(string calldata dataTag, bool encrypted, string calldata note) external onlyAdmin {
        seals.push(PrivacySeal(dataTag, encrypted, note, block.timestamp));
        emit PrivacyLogged(dataTag, encrypted, note, block.timestamp);
    }

    function totalSeals() external view returns (uint256) {
        return seals.length;
    }

    function getSeal(uint256 id) external view returns (PrivacySeal memory) {
        require(id < seals.length, "Invalid id");
        return seals[id];
    }
}
