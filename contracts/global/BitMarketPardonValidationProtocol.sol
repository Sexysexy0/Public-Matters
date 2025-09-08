// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketPardonValidationProtocol {
    address public steward;
    mapping(string => bool) public validatedPardons;

    event PardonValidated(string name, string method, bool isAuthentic, uint timestamp);

    function validatePardon(string memory name, string memory method, bool isAuthentic) public {
        validatedPardons[name] = isAuthentic;
        emit PardonValidated(name, method, isAuthentic, block.timestamp);
    }
}
