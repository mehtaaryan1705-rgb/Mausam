import json
import math
import os

EARTH_RADIUS_KM = 6371.0088
COASTAL_THRESHOLD_KM = 25.0

def haversine_distance(lat1, lon1, lat2, lon2):
    to_rad = lambda deg: (deg * math.pi) / 180.0
    d_lat = to_rad(lat2 - lat1)
    d_lon = to_rad(lon2 - lon1)
    r_lat1 = to_rad(lat1)
    r_lat2 = to_rad(lat2)

    a = (math.sin(d_lat / 2.0) ** 2) + math.cos(r_lat1) * math.cos(r_lat2) * (math.sin(d_lon / 2.0) ** 2)
    c = 2.0 * math.atan2(math.sqrt(a), math.sqrt(1.0 - a))
    return EARTH_RADIUS_KM * c

def distance_to_segment(p_lat, p_lon, a_lat, a_lon, b_lat, b_lon):
    mid_lat = ((a_lat + b_lat) / 2.0) * (math.pi / 180.0)
    cos_mid_lat = math.cos(mid_lat)

    dx = (b_lon - a_lon) * cos_mid_lat
    dy = b_lat - a_lat
    seg_len_sq = dx * dx + dy * dy

    if seg_len_sq < 1e-12:
        return haversine_distance(p_lat, p_lon, a_lat, a_lon)

    px = (p_lon - a_lon) * cos_mid_lat
    py = p_lat - a_lat

    t = (px * dx + py * dy) / seg_len_sq
    t = max(0.0, min(1.0, t))

    proj_lat = a_lat + t * (b_lat - a_lat)
    proj_lon = a_lon + t * (b_lon - a_lon)

    return haversine_distance(p_lat, p_lon, proj_lat, proj_lon)

def check_proximity(lat, lon, json_path):
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    coords = data['features'][0]['geometry']['coordinates']
    min_dist = float('inf')

    for i in range(len(coords) - 1):
        a_lon, a_lat = coords[i]
        b_lon, b_lat = coords[i + 1]
        d = distance_to_segment(lat, lon, a_lat, a_lon, b_lat, b_lon)
        if d < min_dist:
            min_dist = d

    rounded = round(min_dist, 1)
    return {'isCoastal': rounded <= COASTAL_THRESHOLD_KM, 'coastDistanceKm': rounded}

def main():
    base_dir = os.path.dirname(__file__)
    json_path = os.path.join(base_dir, "data", "india_coastline.json")

    test_cases = [
        {'name': 'Mumbai', 'lat': 18.9220, 'lon': 72.8347, 'expected': True, 'maxDist': 3.0},
        {'name': 'Kochi', 'lat': 9.9312, 'lon': 76.2673, 'expected': True, 'maxDist': 5.0},
        {'name': 'Varanasi', 'lat': 25.3176, 'lon': 82.9739, 'expected': False, 'minDist': 500.0},
        {'name': 'New Delhi', 'lat': 28.6139, 'lon': 77.2090, 'expected': False, 'minDist': 500.0},
        {'name': 'Kottayam (Borderline-Inside)', 'lat': 9.5916, 'lon': 76.5222, 'expected': True, 'maxDist': 25.0},
        {'name': 'Pala (Borderline-Outside)', 'lat': 9.7117, 'lon': 76.6833, 'expected': False, 'minDist': 25.0},
    ]

    print("=== VERIFYING COASTLINE PROXIMITY CALCULATION ===")
    for tc in test_cases:
        res = check_proximity(tc['lat'], tc['lon'], json_path)
        print(f"[RESULT] {tc['name']:<22}: dist = {res['coastDistanceKm']} km, isCoastal = {res['isCoastal']}")
        if 'expected' in tc:
            assert res['isCoastal'] == tc['expected'], f"Failed for {tc['name']}"
        if 'maxDist' in tc:
            assert res['coastDistanceKm'] <= tc['maxDist'], f"Dist exceeds max for {tc['name']}"
        if 'minDist' in tc:
            assert res['coastDistanceKm'] >= tc['minDist'], f"Dist less than min for {tc['name']}"

    print("\n[PASS] All 5 coastal detection test cases passed!")

if __name__ == '__main__':
    main()
