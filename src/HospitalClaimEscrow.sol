// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HospitalClaimEscrow {
    address public immutable owner;

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

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the architect");
        _;
    }

    constructor() {
        owner = msg.sender;
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

    function approveClaim(uint256 _id) external onlyOwner {
        Claim storage claim = claims[_id];
        require(!claim.approved, "Already approved");
        require(claim.amount > 0, "Claim does not exist");

        claim.approved = true;
        emit ClaimApproved(_id);
    }

    // Pay the claim from this contract's balance (must be funded by owner)
    function payClaim(uint256 _id) external onlyOwner {
        Claim storage claim = claims[_id];
        require(claim.approved, "Not approved");
        require(!claim.paid, "Already paid");

        claim.paid = true;
        payable(claim.hospital).transfer(claim.amount);
        emit ClaimPaid(_id);
    }

    receive() external payable {}
}
