// SPDX-License-Identifier: FintechSanctum
pragma solidity ^0.8.19;

contract FintechEquitySanctifier {
    struct FintechProtocol {
        string platformName;
        string country;
        bool equityCertified;
        bool unbankedIncluded;
        bool diasporaAccessible;
    }

    mapping(bytes32 => FintechProtocol) public protocols;

    event ProtocolLogged(string platformName, string country, bool unbankedIncluded, bool diasporaAccessible);
    event EquityCertified(string platformName);

    function logProtocol(
        string memory platformName,
        string memory country,
        bool unbankedIncluded,
        bool diasporaAccessible
    ) public {
        bytes32 protocolId = keccak256(abi.encodePacked(platformName, country));
        protocols[protocolId] = FintechProtocol(platformName, country, false, unbankedIncluded, diasporaAccessible);
        emit ProtocolLogged(platformName, country, unbankedIncluded, diasporaAccessible);
    }

    function certifyEquity(string memory platformName, string memory country) public {
        bytes32 protocolId = keccak256(abi.encodePacked(platformName, country));
        require(protocols[protocolId].unbankedIncluded, "Must include unbanked stewards");
        protocols[protocolId].equityCertified = true;
        emit EquityCertified(platformName);
    }

    function isEquityCertified(string memory platformName, string memory country) public view returns (bool) {
        bytes32 protocolId = keccak256(abi.encodePacked(platformName, country));
        return protocols[protocolId].equityCertified;
    }
}
