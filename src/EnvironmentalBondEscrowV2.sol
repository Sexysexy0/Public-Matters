// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title EnvironmentalBondEscrowV2
 * @notice Pull-based bond escrow. Company records address at deposit,
 *         withdraws via pull pattern. Forfeit goes to immutable communityFund.
 */
contract EnvironmentalBondEscrowV2 is ReentrancyGuard {
    OperatorPrivileges public immutable privileges;
    address public immutable communityFund;

    struct Bond {
        uint256 amount;
        address company;
    }

    mapping(bytes32 => Bond) public bonds;
    mapping(address => uint256) public pendingWithdrawals;

    event BondDeposited(bytes32 indexed permitId, address indexed company, uint256 amount);
    event BondReleased(bytes32 indexed permitId, address indexed company, uint256 amount);
    event BondForfeited(bytes32 indexed permitId, address indexed communityFund, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges, address _communityFund) {
        require(_privileges != address(0), "privileges=0");
        require(_communityFund != address(0), "fund=0");
        privileges = OperatorPrivileges(_privileges);
        communityFund = _communityFund;
    }

    function depositBond(bytes32 permitId) external payable nonReentrant {
        require(msg.value > 0, "Bond must be > 0");
        require(bonds[permitId].company == address(0), "Bond already exists");

        bonds[permitId] = Bond({
            amount: msg.value,
            company: msg.sender
        });

        emit BondDeposited(permitId, msg.sender, msg.value);
    }

    function releaseBond(bytes32 permitId) external nonReentrant onlyOperator {
        Bond storage b = bonds[permitId];
        require(b.amount > 0, "No bond");

        // CEI: state bago external call
        uint256 amount = b.amount;
        b.amount = 0;
        pendingWithdrawals[b.company] += amount;

        emit BondReleased(permitId, b.company, amount);
    }

    function forfeitBond(bytes32 permitId) external nonReentrant onlyOperator {
        Bond storage b = bonds[permitId];
        require(b.amount > 0, "No bond");

        // CEI: state bago external call
        uint256 amount = b.amount;
        b.amount = 0;

        // communityFund ay immutable at trusted (multisig), push-based ok
        (bool success, ) = payable(communityFund).call{value: amount}("");
        require(success, "Forfeit failed");

        emit BondForfeited(permitId, communityFund, amount);
    }

    function withdraw() external nonReentrant {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "No funds to withdraw");

        pendingWithdrawals[msg.sender] = 0; // CEI: state bago call
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawal(msg.sender, amount);
    }
}
