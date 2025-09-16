// SPDX-License-Identifier: AgeGateSanctum
pragma solidity ^0.8.19;

contract SocialMediaAgeGateRouter {
    struct UserSignal {
        address user;
        uint8 age;
        bool verified;
        bool restricted;
    }

    mapping(address => UserSignal) public userRegistry;

    event AgeVerified(address user, uint8 age);
    event ContentRestricted(address user);

    function verifyAge(address user, uint8 age) public {
        require(age >= 0 && age <= 120, "Invalid age");
        userRegistry[user] = UserSignal(user, age, true, age < 16);
        emit AgeVerified(user, age);
        if (age < 16) emit ContentRestricted(user);
    }

    function getUserStatus(address user) public view returns (UserSignal memory) {
        return userRegistry[user];
    }
}
