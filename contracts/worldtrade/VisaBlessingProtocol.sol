// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VisaBlessingProtocol {
    address public steward;
    mapping(string => bool) public visaBlessed;

    event VisaGranted(string region);
    event VisaRevoked(string region);

    constructor() {
        steward = msg.sender;
        visaBlessed["India"] = true;
        visaBlessed["Japan"] = true;
        visaBlessed["PH"] = true;
        visaBlessed["China"] = false;
        visaBlessed["Russia"] = false;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function grantVisa(string memory region) public onlySteward {
        visaBlessed[region] = true;
        emit VisaGranted(region);
    }

    function revokeVisa(string memory region) public onlySteward {
        visaBlessed[region] = false;
        emit VisaRevoked(region);
    }

    function isVisaBlessed(string memory region) public view returns (bool) {
        return visaBlessed[region];
    }
}
