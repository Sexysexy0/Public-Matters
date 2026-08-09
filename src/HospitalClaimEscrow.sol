import "./ITrustIntegrator.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HospitalClaimEscrow {
    address public immutable steward;
    ITrustIntegrator public trustIntegrator;

    struct Claim {
        address patient;
        address hospital;
        bytes32 diagnosisHash;
        uint256 amount;
        bool approved;
        bool paid;
    }

    mapping(uint256 => Claim) public claims;
    uint256 public claimCounter;

    event ClaimSubmitted(uint256 id, address patient, address hospital, uint256 amount);
    event ClaimApproved(uint256 id);
    event ClaimPaid(uint256 id);
    event TrustIntegratorUpdated(address newIntegrator);

    modifier onlySteward() {
        require(msg.sender == steward, "Only the steward");
        _;
    }

    constructor(address _trustIntegrator) {
        steward = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function submitClaim(address _patient, address _hospital, bytes32 _diagnosisHash, uint256 _amount) external {
        require(_patient != address(0), "Invalid patient");
        require(_hospital != address(0), "Invalid hospital");
        require(_diagnosisHash != bytes32(0), "Invalid diagnosis");
        require(_amount > 0, "Amount must be > 0");

        claimCounter++;
        claims[claimCounter] = Claim({
            patient: _patient,
            hospital: _hospital,
            diagnosisHash: _diagnosisHash,
            amount: _amount,
            approved: false,
            paid: false
        });

        emit ClaimSubmitted(claimCounter, _patient, _hospital, _amount);
    }

    function approveClaim(uint256 _id) external onlySteward {
        Claim storage claim = claims[_id];
        require(!claim.approved, "Already approved");
        require(claim.amount > 0, "Claim does not exist");

        claim.approved = true;
        emit ClaimApproved(_id);
    }

    function payClaim(uint256 _id) external onlySteward {
        Claim storage claim = claims[_id];
        require(claim.approved, "Not approved");
        require(!claim.paid, "Already paid");
        require(address(this).balance >= claim.amount, "Insufficient balance");

        claim.paid = true;
        payable(claim.hospital).transfer(claim.amount);
        trustIntegrator.logPositiveAction(20);

        emit ClaimPaid(_id);
    }

    function setTrustIntegrator(address _newIntegrator) external onlySteward {
        trustIntegrator = ITrustIntegrator(_newIntegrator);
        emit TrustIntegratorUpdated(_newIntegrator);
    }

    receive() external payable {}
}
