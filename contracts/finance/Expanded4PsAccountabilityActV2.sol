// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Expanded4PsAccountabilityActV2
 * @notice ₱5,000 monthly assistance with audit strikes, use-of-funds proof,
 *         and automatic replacement for repeated misuse.
 */
contract Expanded4PsAccountabilityActV2 {
    address public steward;
    uint256 public monthlyAssistance = 5000 ether; // pegged token value

    struct Family {
        string headName;
        address wallet;
        bool registered;
        uint8 strikeCount;
        bool active;
    }

    struct Proof {
        uint256 month;
        string description; // short use case e.g., "School fees", "Food & utilities"
        string evidenceHash; // off-chain IPFS/Arweave hash or doc ref
        bool approved;
    }

    mapping(address => Family) public families;
    mapping(address => Proof[]) public proofs;
    mapping(address => bool) public auditors;

    address[] public waitlist;

    event FamilyRegistered(address wallet, string headName);
    event AssistanceReleased(address indexed wallet, uint256 amount, uint256 month);
    event ProofSubmitted(address indexed wallet, uint256 month, string evidenceHash);
    event ProofApproved(address indexed wallet, uint256 month);
    event AuditStrike(address indexed wallet, uint8 strikeCount, string reason);
    event FamilyRemoved(address wallet, string reason);
    event FamilyReplaced(address removedWallet, address newWallet);

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuditor() {
        require(auditors[msg.sender], "Not auditor");
        _;
    }

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
    }

    function setAuditor(address _auditor, bool status) external onlySteward {
        auditors[_auditor] = status;
    }

    function registerFamily(address wallet, string calldata headName) external onlySteward {
        families[wallet] = Family(headName, wallet, true, 0, true);
        emit FamilyRegistered(wallet, headName);
    }

    function addToWaitlist(address wallet) external onlySteward {
        waitlist.push(wallet);
    }

    function releaseAssistance(address wallet, uint256 month) external onlySteward {
        Family storage f = families[wallet];
        require(f.registered && f.active, "Not active family");
        (bool sent, ) = payable(wallet).call{value: monthlyAssistance}("");
        require(sent, "Payment failed");
        emit AssistanceReleased(wallet, monthlyAssistance, month);
    }

    function submitProof(uint256 month, string calldata description, string calldata evidenceHash) external {
        require(families[msg.sender].active, "Inactive family");
        proofs[msg.sender].push(Proof(month, description, evidenceHash, false));
        emit ProofSubmitted(msg.sender, month, evidenceHash);
    }

    function approveProof(address wallet, uint256 month) external onlyAuditor {
        Proof[] storage pf = proofs[wallet];
        for (uint256 i; i < pf.length; i++) {
            if (pf[i].month == month && !pf[i].approved) {
                pf[i].approved = true;
                emit ProofApproved(wallet, month);
                return;
            }
        }
        revert("Proof not found");
    }

    function flagMisuse(address wallet, string calldata reason) external onlyAuditor {
        Family storage f = families[wallet];
        require(f.active, "Family inactive");

        f.strikeCount++;
        emit AuditStrike(wallet, f.strikeCount, reason);

        if (f.strikeCount > 3) {
            f.active = false;
            emit FamilyRemoved(wallet, "Exceeded misuse strikes");
            _replaceWithWaitlisted(wallet);
        }
    }

    function _replaceWithWaitlisted(address removedWallet) internal {
        if (waitlist.length > 0) {
            address newWallet = waitlist[waitlist.length - 1];
            waitlist.pop();
            families[newWallet].active = true;
            emit FamilyReplaced(removedWallet, newWallet);
        }
    }

    receive() external payable {}
}
