// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract DamayClauseEnforcer {
    struct ActOfService {
        string beneficiary;
        string purpose;
        uint256 value;
        bool damayIncluded;
        uint256 timestamp;
        address steward;
    }

    ActOfService[] public acts;

    event ServiceLogged(string beneficiary, string purpose, uint256 value, bool damayIncluded, address indexed steward);
    event DamayViolation(address indexed steward, string purpose);

    function logService(
        string memory beneficiary,
        string memory purpose,
        uint256 value,
        bool damayIncluded
    ) public {
        acts.push(ActOfService(beneficiary, purpose, value, damayIncluded, block.timestamp, msg.sender));
        emit ServiceLogged(beneficiary, purpose, value, damayIncluded, msg.sender);

        if (!damayIncluded) {
            emit DamayViolation(msg.sender, purpose);
        }
    }

    function getAllActs() public view returns (ActOfService[] memory) {
        return acts;
    }

    function getDamayViolations() public view returns (ActOfService[] memory) {
        uint256 count;
        for (uint256 i = 0; i < acts.length; i++) {
            if (!acts[i].damayIncluded) count++;
        }

        ActOfService[] memory violations = new ActOfService[](count);
        uint256 j;
        for (uint256 i = 0; i < acts.length; i++) {
            if (!acts[i].damayIncluded) {
                violations[j] = acts[i];
                j++;
            }
        }
        return violations;
    }
}
