// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

/**
 * @title AutomatedBenefitsEscrow
 * @notice Replaces the slow, manual SSS claim process with automated, verifiable payouts.
 *         Employer deducts, Smart Contract holds, Verified Doctor/Hospital triggers release.
 */
contract AutomatedBenefitsEscrow {
    OperatorPrivileges public immutable privileges;

    struct Member {
        bytes32 memberHash; // Hashed SSS/Employee ID
        uint256 totalContributed;
        bool isActive;
    }

    struct MedicalClaim {
        bytes32 memberHash;
        bytes32 hospitalHash; // Verified hospital/clinic
        bytes32 diagnosisHash; // IPFS hash of medical certificate
        uint256 requestedAmount;
        bool released;
    }

    mapping(bytes32 => Member) public members;
    mapping(bytes32 => MedicalClaim) public claims;

    event ContributionLogged(bytes32 indexed memberHash, uint256 amount);
    event ClaimFiled(bytes32 indexed claimId, bytes32 indexed memberHash, bytes32 hospitalHash);
    event BenefitsReleased(bytes32 indexed claimId, bytes32 indexed memberHash, uint256 amount);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    /**
     * @notice Employer/HR logs the monthly contribution.
     */
    function logContribution(bytes32 memberHash, uint256 amount) external payable onlyOperator {
        require(msg.value == amount, "Value mismatch");
        require(amount > 0, "No amount");

        if (!members[memberHash].isActive) {
            members[memberHash] = Member({memberHash: memberHash, totalContributed: 0, isActive: true});
        }

        members[memberHash].totalContributed += amount;
        emit ContributionLogged(memberHash, amount);
    }

    /**
     * @notice Member files a claim. No SSS personnel needed to "receive" paperwork.
     */
    function fileClaim(
        bytes32 claimId,
        bytes32 memberHash,
        bytes32 hospitalHash,
        bytes32 diagnosisHash,
        uint256 requestedAmount
    ) external {
        require(members[memberHash].isActive, "Member not active");
        require(!claims[claimId].released, "Claim already released");

        claims[claimId] = MedicalClaim({
            memberHash: memberHash,
            hospitalHash: hospitalHash,
            diagnosisHash: diagnosisHash,
            requestedAmount: requestedAmount,
            released: false
        });

        emit ClaimFiled(claimId, memberHash, hospitalHash);
    }

    /**
     * @notice Verified Medical Operator (e.g., hospital representative) approves the diagnosis.
     *         Once approved, funds are IMMEDIATELY released to the member's wallet.
     */
    function getClaim(bytes32 claimId) external view returns (MedicalClaim memory) {
        return claims[claimId];
    }

    mapping(address => uint256) public pendingWithdrawals;
    bool private locked;

    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    function verifyAndRelease(bytes32 claimId, address memberWallet) external onlyOperator {
        MedicalClaim storage c = claims[claimId];
        require(!c.released, "Already released");
        require(c.requestedAmount > 0, "No claim amount");
        require(address(this).balance >= c.requestedAmount, "Insufficient escrow funds");

        c.released = true;
        pendingWithdrawals[memberWallet] += c.requestedAmount;

        emit BenefitsReleased(claimId, c.memberHash, c.requestedAmount);
    }

    function withdraw() external nonReentrant {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "Nothing to withdraw");
        pendingWithdrawals[msg.sender] = 0;
        // forge-lint: disable-next-line(reentrancy-eth)
        (bool ok,) = msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");
    }
}
