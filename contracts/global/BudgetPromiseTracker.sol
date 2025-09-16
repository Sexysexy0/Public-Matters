// SPDX-License-Identifier: PromiseSanctum
pragma solidity ^0.8.19;

contract BudgetPromiseTracker {
    struct PromiseSignal {
        string promiseID;
        string department;
        string budgetTag;
        uint256 allocatedAmount;
        bool fulfilled;
        string stewardNote;
    }

    mapping(string => PromiseSignal) public promiseRegistry;

    event PromiseTagged(string promiseID, string department);
    event PromiseFulfilled(string promiseID);

    function tagPromise(string memory promiseID, string memory department, string memory budgetTag, uint256 allocatedAmount, string memory stewardNote) public {
        promiseRegistry[promiseID] = PromiseSignal(promiseID, department, budgetTag, allocatedAmount, false, stewardNote);
        emit PromiseTagged(promiseID, department);
    }

    function fulfillPromise(string memory promiseID) public {
        require(bytes(promiseRegistry[promiseID].department).length > 0, "Promise not tagged");
        promiseRegistry[promiseID].fulfilled = true;
        emit PromiseFulfilled(promiseID);
    }

    function getPromiseStatus(string memory promiseID) public view returns (PromiseSignal memory) {
        return promiseRegistry[promiseID];
    }
}
