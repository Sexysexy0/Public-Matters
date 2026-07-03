import json
import sys

def process_file_stream(file_path):
    try:
        # Hakbang 1: Buksan ang pormal na file memory structure sa disk
        with open(file_path, 'r') as file:
            data = json.load(file)
            
        # Extract dynamic variable parameters mula sa parsed document facts
        facts = data.get("facts", {}).get("us-gaap", {}).get("UnrecognizedTaxBenefits", {}).get("units", {}).get("USD", [])
        
        if not facts:
            # Fallback parameter kung iba ang nesting style ng JSON facts array
            facts = data.get("USD", [])
            
        print(f"{'Fiscal Year':<12} | {'Form':<8} | {'Filing Date':<12} | {'Value (USD)':<15}")
        print("-" * 58)
        
        for record in facts:
            if record.get("form") == "10-K":
                fy = record.get("fy", "N/A")
                form_type = record.get("form", "N/A")
                filed_date = record.get("filed", "N/A")
                val = record.get("val", 0)
                
                print(f"{fy:<12} | {form_type:<8} | {filed_date:<12} | ${val:,}")
                
    except FileNotFoundError:
        print(f"Error: Hindi mahanap ang target telemetry file sa path: {file_path}")
    except Exception as e:
        print(f"Execution Error sa data pipeline audit: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        process_file_stream(sys.argv[1])
    else:
        print("Usage: python3 script/analyze_facts.py <path_to_json_file>")
