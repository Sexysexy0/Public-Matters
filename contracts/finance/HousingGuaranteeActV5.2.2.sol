// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CoopProfitWalletV522 {
    address public steward;
    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }

    constructor() { steward = msg.sender; }

    struct Coop {
        uint256 id;
        string name;
        address[] members;
        uint256[] shareBps; // basis points per member, total 10000
        uint256 balance;
    }

    struct Sale {
        uint256 coopId;
        string description;
        uint256 gross;
        uint256 expenses;
        uint256 net;
        uint256 timestamp;
    }

    uint256 public coopCount;
    mapping(uint256 => Coop) public coops;
    mapping(uint256 => Sale[]) public sales;
    mapping(address => uint256) public memberBalances;

    event CoopFormed(uint256 id, string name);
    event SaleLogged(uint256 coopId, string description, uint256 net);
    event Withdrawal(address member, uint256 amount);

    function formCoop(
        string calldata name,
        address[] calldata members,
        uint256[] calldata shareBps
    ) external onlySteward {
        require(members.length == shareBps.length, "Length mismatch");
        uint256 totalBps;
        for (uint256 i=0; i<shareBps.length; i++) totalBps += shareBps[i];
        require(totalBps == 10000, "Total share != 100%");
        coopCount++;
        coops[coopCount] = Coop(coopCount, name, members, shareBps, 0);
        emit CoopFormed(coopCount, name);
    }

    function logSale(
        uint256 coopId,
        string calldata description,
        uint256 gross,
        uint256 expenses
    ) external onlySteward {
        Coop storage c = coops[coopId];
        uint256 net = gross - expenses;
        c.balance += net;
        sales[coopId].push(Sale(coopId, description, gross, expenses, net, block.timestamp));

        // auto-split
        for (uint256 i=0; i<c.members.length; i++) {
            uint256 shareAmt = (net * c.shareBps[i]) / 10000;
            memberBalances[c.members[i]] += shareAmt;
        }

        emit SaleLogged(coopId, description, net);
    }

    function withdraw() external {
        uint256 amt = memberBalances[msg.sender];
        require(amt > 0, "No balance");
        memberBalances[msg.sender] = 0;
        (bool ok,) = payable(msg.sender).call{value: amt}("");
        require(ok, "Transfer failed");
        emit Withdrawal(msg.sender, amt);
    }

    receive() external payable {}
}
