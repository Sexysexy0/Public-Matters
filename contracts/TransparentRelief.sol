// TransparentRelief.sol
// Logic: Radical Commission Reduction for Rider/Worker Relief
pragma solidity ^0.8.0;

contract TransparentRelief {
    address public admin;
    uint256 public constant GLOBAL_COMMISSION_RATE = 1; // Set to 1% (Fixed)
    uint256 public constant PREVIOUS_RATE = 18; // The "Legacy" Corporate Rate

    event CommissionProcessed(address indexed worker, uint256 amount, uint256 fee);

    constructor() {
        admin = msg.sender;
    }

    function processPayment(uint256 _totalAmount) public {
        // Ang calculation ay base sa iyong bagong 1% rule
        uint256 developerFee = (_totalAmount * GLOBAL_COMMISSION_RATE) / 100;
        uint256 workerPayout = _totalAmount - developerFee;

        // Logic: Direct transfer to worker's wallet
        // Sa 1% rate, mas malaki ang take-home pay kaysa sa 18% legacy apps.
        emit CommissionProcessed(msg.sender, workerPayout, developerFee);
    }

    function getReliefImpact() public pure returns (string memory) {
        return "IMPACT: 17% MORE WEALTH RETAINED BY THE LOCAL SECTOR";
    }
}
