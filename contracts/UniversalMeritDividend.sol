// UniversalMeritDividend.sol
pragma solidity ^0.8.0;

contract UniversalMeritDividend {
    mapping(address => uint256) public meritScore;

    function rewardContribution(address _citizen, uint256 _points) public {
        // Logic: Points from teaching, reforestation, whistleblowing, etc.
        meritScore[_citizen] += _points;
    }

    function claimDividend() public {
        uint256 amount = meritScore[msg.sender] * 1 ether;
        payable(msg.sender).transfer(amount);
        meritScore[msg.sender] = 0; // Reset after claim
    }
}
