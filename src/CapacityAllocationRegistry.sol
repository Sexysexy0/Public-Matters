// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

/**
 * @title CapacityAllocationRegistry
 * @notice On-chain transparency for scarce resource allocation decisions.
 *         Records wafer capacity commitments and variance reports for
 *         memory manufacturers (HBM vs consumer DRAM allocation).
 */
contract CapacityAllocationRegistry {
    OperatorPrivileges public immutable privileges;

    struct CapacityCommitment {
        bytes32 facilityHash;
        uint256 waferCapacity;
        uint256 hbmAllocationBps;
        uint256 consumerAllocationBps;
        uint256 commitmentDate;
        address recordedBy;
    }

    struct VarianceReport {
        bytes32 facilityHash;
        uint256 expectedOutput;
        uint256 actualOutput;
        uint256 varianceBps;
        uint256 reportedAt;
        address reportedBy;
    }

    mapping(bytes32 => CapacityCommitment[]) public commitmentHistory;
    mapping(bytes32 => uint256) public commitmentCount;

    mapping(bytes32 => VarianceReport[]) public varianceHistory;
    mapping(bytes32 => uint256) public varianceCount;

    event CapacityCommitted(
        bytes32 indexed facilityHash,
        uint256 waferCapacity,
        uint256 hbmAllocationBps,
        uint256 consumerAllocationBps,
        uint256 commitmentDate,
        address indexed recordedBy
    );

    event VarianceReported(
        bytes32 indexed facilityHash,
        uint256 expectedOutput,
        uint256 actualOutput,
        uint256 varianceBps,
        address indexed reportedBy
    );

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function recordCommitment(
        bytes32 _facilityHash,
        uint256 _waferCapacity,
        uint256 _hbmAllocationBps,
        uint256 _consumerAllocationBps,
        uint256 _commitmentDate
    ) external onlyOperator {
        require(_facilityHash != bytes32(0), "Invalid facility hash");
        require(_waferCapacity > 0, "Invalid capacity");
        require(
            _hbmAllocationBps + _consumerAllocationBps <= 10000,
            "Allocation exceeds 10000 bps"
        );

        commitmentHistory[_facilityHash].push(
            CapacityCommitment({
                facilityHash: _facilityHash,
                waferCapacity: _waferCapacity,
                hbmAllocationBps: _hbmAllocationBps,
                consumerAllocationBps: _consumerAllocationBps,
                commitmentDate: _commitmentDate,
                recordedBy: msg.sender
            })
        );

        commitmentCount[_facilityHash]++;

        emit CapacityCommitted(
            _facilityHash,
            _waferCapacity,
            _hbmAllocationBps,
            _consumerAllocationBps,
            _commitmentDate,
            msg.sender
        );
    }

    function reportVariance(
        bytes32 _facilityHash,
        uint256 _expectedOutput,
        uint256 _actualOutput,
        uint256 _varianceBps
    ) external onlyOperator {
        require(_facilityHash != bytes32(0), "Invalid facility hash");
        require(_expectedOutput > 0, "Invalid expected output");

        varianceHistory[_facilityHash].push(
            VarianceReport({
                facilityHash: _facilityHash,
                expectedOutput: _expectedOutput,
                actualOutput: _actualOutput,
                varianceBps: _varianceBps,
                reportedAt: block.timestamp,
                reportedBy: msg.sender
            })
        );

        varianceCount[_facilityHash]++;

        emit VarianceReported(
            _facilityHash,
            _expectedOutput,
            _actualOutput,
            _varianceBps,
            msg.sender
        );
    }

    function getCommitmentVersion(
        bytes32 _facilityHash,
        uint256 _version
    ) external view returns (CapacityCommitment memory) {
        require(_version >= 1, "Invalid version");
        require(_version <= commitmentHistory[_facilityHash].length, "Version not found");
        return commitmentHistory[_facilityHash][_version - 1];
    }

    function getVarianceReport(
        bytes32 _facilityHash,
        uint256 _version
    ) external view returns (VarianceReport memory) {
        require(_version >= 1, "Invalid version");
        require(_version <= varianceHistory[_facilityHash].length, "Version not found");
        return varianceHistory[_facilityHash][_version - 1];
    }
}
