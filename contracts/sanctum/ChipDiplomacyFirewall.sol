// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChipDiplomacyFirewall {
    enum Region { UnitedStates, China, Taiwan, Japan, SouthKorea, India, Singapore }
    enum RestrictionLevel { None, Moderate, High, Total }
    enum FirewallStatus { Active, Lifted, Suspended }

    struct ExportFirewall {
        uint256 id;
        Region source;
        Region destination;
        string chipCategory;
        RestrictionLevel restrictionLevel;
        FirewallStatus status;
        string diplomaticClause;
        uint256 activationDate;
    }

    mapping(uint256 => ExportFirewall) public firewallRegistry;
    uint256 public firewallCount;

    event FirewallActivated(uint256 id, Region source, Region destination, string chipCategory);
    event FirewallLifted(uint256 id);
    event FirewallSuspended(uint256 id);

    function activateFirewall(
        Region source,
        Region destination,
        string memory chipCategory,
        RestrictionLevel restrictionLevel,
        string memory diplomaticClause,
        uint256 activationDate
    ) public {
        firewallRegistry[firewallCount] = ExportFirewall(
            firewallCount,
            source,
            destination,
            chipCategory,
            restrictionLevel,
            FirewallStatus.Active,
            diplomaticClause,
            activationDate
        );
        emit FirewallActivated(firewallCount, source, destination, chipCategory);
        firewallCount++;
    }

    function liftFirewall(uint256 id) public {
        require(id < firewallCount, "Invalid firewall ID");
        firewallRegistry[id].status = FirewallStatus.Lifted;
        emit FirewallLifted(id);
    }

    function suspendFirewall(uint256 id) public {
        require(id < firewallCount, "Invalid firewall ID");
        firewallRegistry[id].status = FirewallStatus.Suspended;
        emit FirewallSuspended(id);
    }

    function getFirewall(uint256 id) public view returns (ExportFirewall memory) {
        return firewallRegistry[id];
    }
}
