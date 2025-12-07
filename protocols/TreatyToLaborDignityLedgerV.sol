// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * TreatyToLaborDignityLedgerV — Batch 1321.9.261
 * Focus: overtime fairness, happy workplace, repair rights interface
 */
contract TreatyToLaborDignityLedgerV {
    address public steward;
    uint256 public version = 1321_9_261;

    struct Worker {
        string id;
        string role;
        uint256 baseRate;      // hourly
        uint256 overtimeRate;  // hourly
        bool repairRights;     // right-to-repair support in workplace tools
        bool dignityPledge;    // org pledge to humane practices
    }

    mapping(bytes32 => Worker) public workers;

    event WorkerRegistered(bytes32 indexed key, string id, string role);
    event RatesUpdated(bytes32 indexed key, uint256 baseRate, uint256 overtimeRate);
    event DignityUpdated(bytes32 indexed key, bool repairRights, bool dignityPledge);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function keyFor(string memory id) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(id));
    }

    function registerWorker(
        string calldata id,
        string calldata role,
        uint256 baseRate,
        uint256 overtimeRate
    ) external onlySteward {
        bytes32 k = keyFor(id);
        workers[k] = Worker(id, role, baseRate, overtimeRate, false, false);
        emit WorkerRegistered(k, id, role);
    }

    function updateRates(
        string calldata id,
        uint256 baseRate,
        uint256 overtimeRate
    ) external onlySteward {
        bytes32 k = keyFor(id);
        Worker storage w = workers[k];
        w.baseRate = baseRate;
        w.overtimeRate = overtimeRate;
        emit RatesUpdated(k, baseRate, overtimeRate);
    }

    function setDignity(
        string calldata id,
        bool repairRights,
        bool dignityPledge
    ) external onlySteward {
        bytes32 k = keyFor(id);
        Worker storage w = workers[k];
        w.repairRights = repairRights;
        w.dignityPledge = dignityPledge;
        emit DignityUpdated(k, repairRights, dignityPledge);
    }
}
