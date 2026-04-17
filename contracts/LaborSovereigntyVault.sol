// LaborSovereigntyVault.sol
pragma solidity ^0.8.0;

contract LaborSovereigntyVault {
    mapping(address => uint256) public workerBalance;

    function secureWages(address _worker) public payable {
        // Direct deposit from employer/contractor
        // Protected from government-led bank freezes
        workerBalance[_worker] += msg.value;
    }

    function withdraw() public {
        uint256 amount = workerBalance[msg.sender];
        workerBalance[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
