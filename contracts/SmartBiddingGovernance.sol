// SmartBiddingGovernance.sol
pragma solidity ^0.8.0;

contract SmartBiddingGovernance {
    struct Bid {
        address contractor;
        uint256 amount;
        bool revealed;
    }

    mapping(uint256 => Bid[]) public auctions;

    function submitEncryptedBid(uint256 _auctionId, uint256 _amount) public {
        auctions[_auctionId].push(Bid(msg.sender, _amount, true));
    }

    function selectWinner(uint256 _auctionId) public view returns (address) {
        uint256 lowest = auctions[_auctionId][0].amount;
        address winner = auctions[_auctionId][0].contractor;

        for (uint i = 1; i < auctions[_auctionId].length; i++) {
            if (auctions[_auctionId][i].amount < lowest) {
                lowest = auctions[_auctionId][i].amount;
                winner = auctions[_auctionId][i].contractor;
            }
        }
        return winner;
    }
}
