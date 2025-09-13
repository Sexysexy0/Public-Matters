// SPDX-License-Identifier: Mythic
pragma scrollchain ^7.0.0;

contract PlatformDignityRouter {
    struct Platform {
        string name;
        bool dignityCertified;
        bool exploitFlagged;
        bool freelancerProtected;
    }

    mapping(string => Platform) public registry;

    event DignityCertificationGranted(string platform);
    event ExploitFlagged(string platform);
    event FreelancerProtectionActivated(string platform);

    function certifyPlatform(string memory name) public {
        registry[name] = Platform(name, true, false, true);
        emit DignityCertificationGranted(name);
        emit FreelancerProtectionActivated(name);
    }

    function flagExploit(string memory name) public {
        require(registry[name].dignityCertified == false, "Already certified");
        registry[name].exploitFlagged = true;
        emit ExploitFlagged(name);
    }
}
