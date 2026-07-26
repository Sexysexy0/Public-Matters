pragma solidity ^0.8.0;

contract GenevaViolationArchive {
    event ViolationEntry(string violator, string article);

    function recordBreach(string memory violator, string memory article) public {
        emit ViolationEntry(violator, article);
    }
}
