// SPDX-License-Identifier: Treaty-License
pragma solidity ^0.8.0;

contract CannabisLicenseCascade {
    address public steward;

    struct SubEntity {
        address entity;
        string region;
        bool approved;
        uint timestamp;
    }

    mapping(address => SubEntity[]) public hostedEntities;

    event SubEntityApplied(address indexed host, address indexed subEntity, string region, uint timestamp);
    event SubEntityApproved(address indexed host, address indexed subEntity, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function applyCascade(address host, address subEntity, string memory region) public {
        require(msg.sender == steward, "Only steward can initiate cascade");
        hostedEntities[host].push(SubEntity(subEntity, region, false, block.timestamp));
        emit SubEntityApplied(host, subEntity, region, block.timestamp);
    }

    function approveSubEntity(address host, uint index) public {
        require(msg.sender == steward, "Only steward can approve");
        hostedEntities[host][index].approved = true;
        emit SubEntityApproved(host, hostedEntities[host][index].entity, block.timestamp);
    }

    function getHostedEntities(address host) public view returns (SubEntity[] memory) {
        return hostedEntities[host];
    }
}
