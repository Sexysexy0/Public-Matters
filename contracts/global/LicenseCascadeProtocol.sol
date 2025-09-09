// SPDX-License-Identifier: Equity-License
pragma solidity ^0.8.0;

contract LicenseCascadeProtocol {
    address public steward;
    mapping(address => bool) public licensedHosts;
    mapping(address => address) public subEntityHost;

    event HostRegistered(address indexed host);
    event SubEntityLinked(address indexed subEntity, address indexed host);

    function registerHost(address host) public {
        require(msg.sender == steward, "Only steward can register");
        licensedHosts[host] = true;
        emit HostRegistered(host);
    }

    function linkSubEntity(address subEntity, address host) public {
        require(licensedHosts[host], "Host must be registered");
        subEntityHost[subEntity] = host;
        emit SubEntityLinked(subEntity, host);
    }

    function getHost(address subEntity) public view returns (address) {
        return subEntityHost[subEntity];
    }
}
