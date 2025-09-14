// SPDX-License-Identifier: SovereignSanctum
pragma solidity ^0.8.19;

contract DefenseSovereigntyRouter {
    struct Contributor {
        string name;
        string country;
        bool isCitizen;
        bool isAuthorized;
    }

    mapping(address => Contributor) public registry;

    event ContributorRegistered(address indexed steward, string name, string country, bool isCitizen);
    event AuthorizationUpdated(address indexed steward, bool isAuthorized);

    function registerContributor(string memory name, string memory country, bool isCitizen) public {
        registry[msg.sender] = Contributor(name, country, isCitizen, false);
        emit ContributorRegistered(msg.sender, name, country, isCitizen);
    }

    function authorizeContributor(address steward) public {
        require(registry[steward].isCitizen, "Non-citizen contributors cannot be authorized");
        registry[steward].isAuthorized = true;
        emit AuthorizationUpdated(steward, true);
    }

    function revokeAuthorization(address steward) public {
        registry[steward].isAuthorized = false;
        emit AuthorizationUpdated(steward, false);
    }

    function isAuthorized(address steward) public view returns (bool) {
        return registry[steward].isAuthorized;
    }
}
