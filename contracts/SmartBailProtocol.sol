// SmartBailProtocol.sol
pragma solidity ^0.8.0;

contract SmartBailProtocol {
    struct BailInfo {
        uint256 bailAmount;
        bool isPaid;
        bool isForfeited;
    }

    mapping(address => BailInfo) public bailRegistry;

    function postBail() public payable {
        require(msg.value >= bailRegistry[msg.sender].bailAmount, "Insufficient amount");
        bailRegistry[msg.sender].isPaid = true;
    }

    function refundBail(address _defendant) public {
        // Refund if case is won or defendant complied with all hearings
        require(bailRegistry[_defendant].isPaid && !bailRegistry[_defendant].isForfeited);
        payable(_defendant).transfer(bailRegistry[_defendant].bailAmount);
    }
}
