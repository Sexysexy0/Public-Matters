// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PassportNullifier {
    address public steward;
    mapping(string => bool) public passportValid;

    event PassportRevoked(string region);
    event PassportRestored(string region);

    constructor() {
        steward = msg.sender;
        passportValid["China"] = false;
        passportValid["Russia"] = false;
        passportValid["India"] = true;
        passportValid["Japan"] = true;
        passportValid["PH"] = true;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function revokePassport(string memory region) public onlySteward {
        passportValid[region] = false;
        emit PassportRevoked(region);
    }

    function restorePassport(string memory region) public onlySteward {
        passportValid[region] = true;
        emit PassportRestored(region);
    }

    function isPassportValid(string memory region) public view returns (bool) {
        return passportValid[region];
    }
}
