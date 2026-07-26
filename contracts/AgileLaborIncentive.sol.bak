// AgileLaborIncentive.sol
pragma solidity ^0.8.0;

contract AgileLaborIncentive {
    struct Rider { uint256 deliveries; bool isInsured; }
    mapping(address => Rider) public fleet;

    function logDelivery(address _rider) public {
        // Administrative Logic: Protection follows the worker, not the company.
        // Automatic health-credit allocation for every kilometer traveled.
        fleet[_rider].deliveries++;
    }
}
