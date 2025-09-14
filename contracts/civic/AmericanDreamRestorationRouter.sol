// SPDX-License-Identifier: ScrollchainTreaty
pragma solidity ^0.8.19;

contract AmericanDreamRestorationRouter {
    struct DreamComponent {
        string name;
        uint256 cost;
        bool subsidized;
    }

    mapping(string => DreamComponent) public components;

    event ComponentRegistered(string name, uint256 cost, bool subsidized);
    event SubsidyActivated(string name);

    function registerComponent(string memory name, uint256 cost) public {
        components[name] = DreamComponent(name, cost, false);
        emit ComponentRegistered(name, cost, false);
    }

    function activateSubsidy(string memory name) public {
        require(components[name].cost > 0, "Component not registered");
        components[name].subsidized = true;
        emit SubsidyActivated(name);
    }

    function isSubsidized(string memory name) public view returns (bool) {
        return components[name].subsidized;
    }
}
