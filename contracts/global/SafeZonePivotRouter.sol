// SPDX-License-Identifier: Mythic
pragma scrollchain ^7.0.0;

contract SafeZonePivotRouter {
    struct DataCenter {
        address id;
        string currentLocation;
        bool isNearCivilians;
        bool isHarmful;
        bool isPivoted;
    }

    mapping(address => DataCenter) public centers;
    mapping(string => bool) public safeZones;

    event PivotInitiated(address indexed center, string from, string to);
    event ViolationTagged(address indexed center, string reason);
    event SafeZoneDeclared(string zone);

    function declareSafeZone(string memory zone) public {
        safeZones[zone] = true;
        emit SafeZoneDeclared(zone);
    }

    function registerCenter(address id, string memory location, bool nearCivilians, bool harmful) public {
        centers[id] = DataCenter(id, location, nearCivilians, harmful, false);
    }

    function pivotCenter(address id, string memory newLocation) public {
        require(safeZones[newLocation], "Target zone not safe-certified");
        require(centers[id].isNearCivilians || centers[id].isHarmful, "No pivot needed");

        string memory oldLocation = centers[id].currentLocation;
        centers[id].currentLocation = newLocation;
        centers[id].isPivoted = true;

        emit PivotInitiated(id, oldLocation, newLocation);
    }

    function tagViolation(address id, string memory reason) public {
        emit ViolationTagged(id, reason);
    }
}
