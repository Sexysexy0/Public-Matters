// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DebtForgivenessProtocol {
    struct ForgivenessScroll {
        string debtor;
        uint256 originalDebt;
        uint256 forgivenAmount;
        string mercyNote;
        uint256 emotionalAPRRestored;
        bool active;
    }

    ForgivenessScroll[] public scrolls;

    event DebtForgiven(string debtor, uint256 forgivenAmount, string mercyNote);

    function forgiveDebt(
        string memory _debtor,
        uint256 _originalDebt,
        uint256 _forgivenAmount,
        string memory _mercyNote,
        uint256 _emotionalAPRRestored
    ) public {
        scrolls.push(ForgivenessScroll(_debtor, _originalDebt, _forgivenAmount, _mercyNote, _emotionalAPRRestored, true));
        emit DebtForgiven(_debtor, _forgivenAmount, _mercyNote);
    }

    function getAllForgivenessScrolls() public view returns (ForgivenessScroll[] memory) {
        return scrolls;
    }
}
