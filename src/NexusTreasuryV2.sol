// SPDX-License-Identifier: WIZARD-GENESIS-V1
pragma solidity ^0.8.24;

contract NexusTreasuryV2 {
    address public admin;
    event Allocated(address indexed to, uint256 amount, string reason);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    // Para maka-receive ng ETH
    receive() external payable {}

    // Mag-allocate ng totoong ETH mula sa Treasury papunta sa recipient
    function allocate(address _to, uint256 _amount, string memory _reason) public onlyAdmin {
        require(address(this).balance >= _amount, "Insufficient ETH balance");
        (bool success,) = _to.call{value: _amount}("");
        require(success, "Transfer failed");
        emit Allocated(_to, _amount, _reason);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
