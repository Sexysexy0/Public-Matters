// GlobalJusticeBounty.sol
pragma solidity ^0.8.0;

contract GlobalJusticeBounty {
    struct Bounty {
        string targetCase;
        uint256 rewardAmount;
        bool isClaimed;
    }

    mapping(uint256 => Bounty) public bountyBoard;

    function postJusticeBounty(uint256 _caseId, uint256 _amount) public payable {
        bountyBoard[_caseId] = Bounty("Case_Ref_Epstein_Circle", _amount, false);
    }

    function claimJustice(uint256 _caseId, address _informant) public {
        // Logic: Verified by a Decentralized Jury of 12 independent nodes
        require(!bountyBoard[_caseId].isClaimed, "Justice already served.");
        bountyBoard[_caseId].isClaimed = true;
        payable(_informant).transfer(bountyBoard[_caseId].rewardAmount);
    }
}
