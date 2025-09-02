# 🌀 Prophecy Loop Watcher
# Tracks algorithmic prophecy spikes and emotional resonance loops

import time
import json

def watch_loop(feed_path):
    with open(feed_path, 'r') as f:
        feed = json.load(f)
    for event in feed["prophecyEvents"]:
        if event["clarity"] < 0.5:
            print(f"⚠️ Low clarity detected in prophecy: {event['message']}")
        if event["trust"] < 0.3:
            print(f"🔴 Trust breach in loop: {event['message']}")
        time.sleep(1)

if __name__ == "__main__":
    feed_path = "feeds/prophecy/ProphecyLoop.json"
    watch_loop(feed_path)
