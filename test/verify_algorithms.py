import json
import os
import math

def compute_comfort_index(temperature, relative_humidity, wind_speed_kmh):
    temp_penalty = abs(temperature - 22.0) * 2.2
    humidity_penalty = (relative_humidity - 50) * 0.45 if relative_humidity > 50 else 0.0
    wind_bonus = min(10.0, max(0.0, wind_speed_kmh * 0.4))
    raw_score = 100.0 - temp_penalty - humidity_penalty + wind_bonus
    return round(max(10.0, min(100.0, raw_score)))

def generate_packing_suggestions(temp, rain_probability, uv_index, aqi):
    suggestions = []
    if rain_probability >= 50:
        suggestions.append(f"Waterproof gear: Raincoat, umbrella ({rain_probability}% rain)")
    if uv_index >= 7.0:
        suggestions.append("High UV protection: Broad-spectrum SPF 50 sunscreen")
    if aqi >= 180:
        suggestions.append(f"Respiratory shield: Carry certified N95 masks (AQI {aqi})")
    if temp <= 16.0:
        suggestions.append(f"Thermal wear: Fleece jacket ({temp}°C)")
    elif temp >= 32.0:
        suggestions.append("Breathable clothing: Lightweight cotton attire")
    return suggestions

def test_all():
    print("=== MAUSAM ALGORITHM & DATA VALIDATION ===")

    # Test 1: Comfort Index
    c1 = compute_comfort_index(22.0, 50, 12.0)
    assert 95 <= c1 <= 100, f"Expected ~99, got {c1}"
    print(f"[PASS] Comfort Index (Optimal: 22C, 50% RH, 12 km/h) -> {c1}/100")

    c2 = compute_comfort_index(38.0, 80, 5.0)
    assert c2 < 60, f"Expected < 60, got {c2}"
    print(f"[PASS] Comfort Index (Harsh: 38C, 80% RH, 5 km/h) -> {c2}/100")

    # Test 2: Packing suggestions
    pack = generate_packing_suggestions(33.0, 75, 8.5, 220)
    assert any("Waterproof" in s for s in pack), "Missing rain gear"
    assert any("UV protection" in s for s in pack), "Missing UV gear"
    assert any("N95" in s for s in pack), "Missing AQI gear"
    print(f"[PASS] Packing Suggestion Generator -> {len(pack)} tailored items generated")

    # Test 3: Validate Mock JSON schemas for Backend
    base_dir = os.path.dirname(__file__)
    delhi_path = os.path.join(base_dir, "..", "backend", "mock_data", "weather_delhi.json")
    mumbai_path = os.path.join(base_dir, "..", "backend", "mock_data", "weather_mumbai.json")

    for path, name, is_coastal in [(delhi_path, "Delhi", False), (mumbai_path, "Mumbai", True)]:
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)
        assert data["cityName"] in ["New Delhi", "Mumbai"], "City name mismatch"
        assert data["isCoastal"] == is_coastal, f"{name} coastal flag mismatch"
        assert "aqi" in data and "aqi" in data["aqi"], "Missing AQI data"
        assert "outdoorFitness" in data, "Missing Outdoor Fitness data"
        assert "traveler" in data, "Missing Traveler data"
        assert "parentsFamilies" in data, "Missing Parents/Families data"
        assert "agriculture" in data, "Missing Agriculture data"
        assert "commuter" in data, "Missing Commuter data"
        assert "eventPlanner" in data, "Missing Event Planner data"
        if is_coastal:
            assert data["tideSea"] is not None, "Coastal city must have tideSea data"
            assert "waveHeightM" in data["tideSea"], "Missing wave height in coastal data"
        else:
            assert data["tideSea"] is None, "Inland city must have null tideSea"

        print(f"[PASS] {name} Schema & 8 Personas Verification")

    print("\nALL ALGORITHM & DATA INTEGRITY TESTS PASSED SUCCESSFULLY!")

if __name__ == "__main__":
    test_all()
