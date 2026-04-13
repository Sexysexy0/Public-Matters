// StakeholderFeedbackDAO.sol
pragma solidity ^0.8.0;

contract StakeholderFeedbackDAO {
    struct Inquiry {
        address stakeholder;
        string issue;
        uint256 timestamp;
        bool resolved;
        address responder;
    }

    mapping(uint256 => Inquiry) public tickets;
    uint256 public ticketCount;

    function fileInquiry(string memory _issue) public {
        ticketCount++;
        tickets[ticketCount] = Inquiry(msg.sender, _issue, block.timestamp, false, address(0));
    }

    function resolveInquiry(uint256 _id) public {
        tickets[_id].resolved = true;
        tickets[_id].responder = msg.sender;
    }
}
