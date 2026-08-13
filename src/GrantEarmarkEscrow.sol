// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GrantEarmarkEscrow {
    enum GrantStatus { Active, Completed, Clawbacked }

    struct Grant {
        bytes32 grantId;
        address payable grantee;
        address donor;
        uint256 totalAmount;
        uint256 disbursedAmount;
        uint256 expiryBlock;
        GrantStatus status;
    }

    address public admin;
    mapping(bytes32 => Grant) public grants;

    event GrantCreated(bytes32 indexed grantId, address indexed donor, address indexed grantee, uint256 amount);
    event TrancheDisbursed(bytes32 indexed grantId, uint256 amount);
    event GrantClawbacked(bytes32 indexed grantId, uint256 refundedAmount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Unauthorized: Admin only");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createGrant(bytes32 _rawId, address payable _grantee, uint256 _durationSeconds)
        external
        payable
        returns (bytes32)
    {
        require(msg.value > 0, "Grant amount must be > 0");
        bytes32 grantId = keccak256(abi.encodePacked(_rawId, msg.sender, _grantee, block.number));
        require(grants[grantId].totalAmount == 0, "Grant exists");

        uint256 secondsPerBlock = 12;
        grants[grantId] = Grant({
            grantId: grantId,
            grantee: _grantee,
            donor: msg.sender,
            totalAmount: msg.value,
            disbursedAmount: 0,
            expiryBlock: block.number + (_durationSeconds / secondsPerBlock),
            status: GrantStatus.Active
        });

        emit GrantCreated(grantId, msg.sender, _grantee, msg.value);
        return grantId;
    }

    function disburseTranche(bytes32 _grantId, uint256 _amount) external onlyAdmin {
        Grant storage g = grants[_grantId];
        require(g.status == GrantStatus.Active, "Grant not active");
        require(g.disbursedAmount + _amount <= g.totalAmount, "Exceeds allocated total");

        g.disbursedAmount += _amount;
        if (g.disbursedAmount == g.totalAmount) {
            g.status = GrantStatus.Completed;
        }

        (bool success,) = g.grantee.call{value: _amount}("");
        require(success, "Disbursement failed");

        emit TrancheDisbursed(_grantId, _amount);
    }

    function clawbackExpiredGrant(bytes32 _grantId) external {
        Grant storage g = grants[_grantId];
        require(g.status == GrantStatus.Active, "Grant not active");
        require(block.number >= g.expiryBlock, "Grant not expired yet");
        require(msg.sender == g.donor || msg.sender == admin, "Unauthorized clawback");

        uint256 remainingFunds = g.totalAmount - g.disbursedAmount;
        require(remainingFunds > 0, "No funds remaining");

        g.status = GrantStatus.Clawbacked;

        (bool success,) = payable(g.donor).call{value: remainingFunds}("");
        require(success, "Refund failed");

        emit GrantClawbacked(_grantId, remainingFunds);
    }
}
