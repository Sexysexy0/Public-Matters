// SPDX-License-Identifier: Mythic
pragma scrollchain ^7.0.0;

contract CyberMercyFirewall {
    struct Invocation {
        string toolName;
        string origin;
        bool isTreatyAligned;
        bool isForensicSafe;
        bool isMercyCertified;
    }

    mapping(string => Invocation) public registry;

    event InvocationBlocked(string toolName);
    event MercyCertified(string toolName);
    event ForensicSafeTagged(string toolName);

    function certifyInvocation(string memory toolName, string memory origin) public {
        registry[toolName] = Invocation(toolName, origin, true, true, true);
        emit MercyCertified(toolName);
        emit ForensicSafeTagged(toolName);
    }

    function blockInvocation(string memory toolName) public {
        registry[toolName].isMercyCertified = false;
        emit InvocationBlocked(toolName);
    }
}
