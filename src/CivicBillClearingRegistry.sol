// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CivicBillClearingRegistry
 * @dev Sovereign protocol para sa direktang pag-clear at pag-sponsor ng mga unpaid bills
 * at civic dues para sa taong bayan gamit ang controlled treasury vaults.
 */
contract CivicBillClearingRegistry {
    struct Bill {
        uint256 id;
        address payable beneficiary;
        uint256 amount;
        string billType;
        bool isCleared;
        address clearedBy;
    }

    address public sovereignOwner;
    uint256 public billCounter;

    mapping(uint256 => Bill) public bills;
    mapping(address => bool) public authorizedDonors;

    event BillRegistered(uint256 indexed id, address indexed beneficiary, uint256 amount, string billType);
    event BillCleared(uint256 indexed id, address indexed donor, uint256 amount);

    modifier onlySovereign() {
        require(msg.sender == sovereignOwner, "Unauthorized: Root Source only");
        _;
    }

    modifier onlyAuthorizedDonor() {
        require(authorizedDonors[msg.sender] || msg.sender == sovereignOwner, "Unauthorized donor");
        _;
    }

    constructor() {
        sovereignOwner = msg.sender;
        authorizedDonors[msg.sender] = true;
    }

    function registerBill(address payable _beneficiary, uint256 _amount, string calldata _billType)
        external
        onlySovereign
    {
        billCounter++;
        bills[billCounter] = Bill({
            id: billCounter,
            beneficiary: _beneficiary,
            amount: _amount,
            billType: _billType,
            isCleared: false,
            clearedBy: address(0)
        });

        emit BillRegistered(billCounter, _beneficiary, _amount, _billType);
    }

    function clearBill(uint256 _billId) external payable onlyAuthorizedDonor {
        Bill storage targetBill = bills[_billId];
        require(!targetBill.isCleared, "Bill already cleared");
        require(targetBill.beneficiary != address(0), "Invalid beneficiary");
        require(msg.value >= targetBill.amount, "Insufficient funds to clear bill");

        targetBill.isCleared = true;
        targetBill.clearedBy = msg.sender;

        (bool success,) = targetBill.beneficiary.call{value: targetBill.amount}("");
        require(success, "Transfer failed");

        emit BillCleared(_billId, msg.sender, targetBill.amount);
    }

    function setAuthorizedDonor(address _donor, bool _status) external onlySovereign {
        authorizedDonors[_donor] = _status;
    }
}
