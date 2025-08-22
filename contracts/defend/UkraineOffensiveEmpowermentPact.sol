// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract UkraineOffensiveEmpowermentPact is Ownable, ReentrancyGuard {
    event PledgeMade(address indexed participant, uint256 amount, string commitmentType);
    event AidReleased(address indexed toUkraine, uint256 amount, string milestone);
    event OffensiveMilestoneAchieved(string description, uint256 timestamp);
    event ConsultationTriggered(string reason, uint256 timestamp);

    struct Commitment {
        uint256 pledgedAmount;
        uint256 releasedAmount;
        bool isOffensiveEnabled;
        string participantName;
    }

    mapping(address => Commitment) public commitments;
    mapping(string => bool) public milestoneRegistry;

    address public ukraineAddress;
    IERC20 public aidToken;
    uint256 public startTime;
    uint256 public constant DURATION = 10 * 365 days;

    address public vinSanctumDefenseProtocol;
    address public kapamilyaDefenseCovenant;

    modifier pactActive() {
        require(block.timestamp >= startTime && block.timestamp < startTime + DURATION, "Pact not active");
        _;
    }

    constructor(
        address[] memory _participants,
        string[] memory _names,
        uint256[] memory _annualPledges,
        address _ukraineAddress,
        IERC20 _aidToken,
        address _vinSanctum,
        address _kapamilya
    ) Ownable(msg.sender) {
        require(_participants.length == _names.length && _names.length == _annualPledges.length, "Array mismatch");
        for (uint256 i = 0; i < _participants.length; i++) {
            commitments[_participants[i]] = Commitment({
                pledgedAmount: 0,
                releasedAmount: 0,
                isOffensiveEnabled: false,
                participantName: _names[i]
            });
        }
        ukraineAddress = _ukraineAddress;
        aidToken = _aidToken;
        vinSanctumDefenseProtocol = _vinSanctum;
        kapamilyaDefenseCovenant = _kapamilya;
        startTime = block.timestamp;
    }

    function getAnnualPledge(address participant) public view returns (uint256) {
        string memory name = commitments[participant].participantName;
        if (keccak256(bytes(name)) == keccak256("United States")) return 15_000_000_000 ether;
        if (keccak256(bytes(name)) == keccak256("United Kingdom")) return 3_500_000_000 ether;
        if (keccak256(bytes(name)) == keccak256("Australia")) return 2_500_000_000 ether;
        if (keccak256(bytes(name)) == keccak256("European Union")) return 20_000_000_000 ether;
        return 0;
    }

    function pledgeAid() external payable pactActive nonReentrant {
        require(bytes(commitments[msg.sender].participantName).length > 0, "Not a registered participant");
        uint256 annualPledge = getAnnualPledge(msg.sender);
        uint256 amount;

        if (address(aidToken) == address(0)) {
            amount = msg.value;
            require(amount >= annualPledge, "Insufficient ETH pledge");
        } else {
            require(msg.value == 0, "ETH not accepted for token pledges");
            amount = annualPledge;
            aidToken.transferFrom(msg.sender, address(this), amount);
        }

        commitments[msg.sender].pledgedAmount += amount;
        commitments[msg.sender].isOffensiveEnabled = true;

        emit PledgeMade(msg.sender, amount, "Annual Offensive Aid");
    }

    function releaseAid(uint256 _amount, string calldata _milestone) external onlyOwner pactActive nonReentrant {
        require(_amount > 0, "Invalid amount");
        uint256 totalAvailable;
        address[] memory participants = getParticipants();

        for (uint256 i = 0; i < participants.length; i++) {
            totalAvailable += commitments[participants[i]].pledgedAmount - commitments[participants[i]].releasedAmount;
        }

        require(_amount <= totalAvailable, "Insufficient funds");

        for (uint256 i = 0; i < participants.length; i++) {
            Commitment storage c = commitments[participants[i]];
            uint256 available = c.pledgedAmount - c.releasedAmount;
            uint256 share = (_amount * available) / totalAvailable;
            c.releasedAmount += share;
        }

        if (address(aidToken) == address(0)) {
            payable(ukraineAddress).transfer(_amount);
        } else {
            aidToken.transfer(ukraineAddress, _amount);
        }

        milestoneRegistry[_milestone] = true;
        emit AidReleased(ukraineAddress, _amount, _milestone);
        emit OffensiveMilestoneAchieved(_milestone, block.timestamp);
    }

    function getParticipants() public view returns (address[] memory) {
        uint256 count;
        for (uint256 i = 0; i < 100; i++) {
            // Placeholder: Replace with actual participant tracking
        }
        return new address[](0); // Placeholder
    }

    function getTotalPledged() external view returns (uint256 total) {
        for (uint256 i = 0; i < 100; i++) {
            // Placeholder
        }
    }

    function getTotalReleased() external view returns (uint256 total) {
        for (uint256 i = 0; i < 100; i++) {
            // Placeholder
        }
    }

    function triggerConsultation(string calldata _reason) external pactActive {
        emit ConsultationTriggered(_reason, block.timestamp);
    }

    function withdrawRemaining() external onlyOwner {
        require(block.timestamp >= startTime + DURATION, "Pact still active");
        uint256 balance = address(aidToken) == address(0) ? address(this).balance : aidToken.balanceOf(address(this));
        if (address(aidToken) == address(0)) {
            payable(owner()).transfer(balance);
        } else {
            aidToken.transfer(owner(), balance);
        }
    }

    receive() external payable {}
}
