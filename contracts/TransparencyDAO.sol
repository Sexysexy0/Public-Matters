// TransparencyDAO.sol
pragma solidity ^0.8.0;

contract TransparencyDAO {
    struct Directive {
        uint256 id;
        string policy;   // e.g. "Require credible sources"
        bool active;
    }

    uint256 public directiveCount;
    mapping(uint256 => Directive) public directives;

    event DirectiveActivated(uint256 id, string policy);

    function activateDirective(string memory policy) public {
        directiveCount++;
        directives[directiveCount] = Directive(directiveCount, policy, true);
        emit DirectiveActivated(directiveCount, policy);
    }
}
