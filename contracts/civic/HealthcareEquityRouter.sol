// SPDX-License-Identifier: MercySanctum
pragma solidity ^0.8.19;

contract HealthcareEquityRouter {
    struct Provider {
        string name;
        bool dignityCertified;
        uint256 cappedRate;
    }

    mapping(address => Provider) public registry;

    event ProviderRegistered(address indexed steward, string name, uint256 cappedRate);
    event CertificationUpdated(address indexed steward, bool dignityCertified);

    function registerProvider(string memory name, uint256 cappedRate) public {
        registry[msg.sender] = Provider(name, true, cappedRate);
        emit ProviderRegistered(msg.sender, name, cappedRate);
    }

    function updateCertification(address steward, bool certified) public {
        registry[steward].dignityCertified = certified;
        emit CertificationUpdated(steward, certified);
    }

    function getRate(address steward) public view returns (uint256) {
        return registry[steward].cappedRate;
    }
}
