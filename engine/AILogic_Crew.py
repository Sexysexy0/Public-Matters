# [Goal: Intelligent NPC delegation for resource gathering and sailing]
class CrewAI:
    def __init__(self, role):
        self.role = role # "Pilot", "Harvester", "Defender"

    def execute_task(self, command):
        if command == "AUTO_SAIL":
            self.engage_pathfinding(target_coords)
        elif command == "GRIND_RESOURCES":
            self.start_farming_loop(radius=500)
