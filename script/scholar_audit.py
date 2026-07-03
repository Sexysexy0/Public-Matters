import urllib.request
import urllib.parse
import json
import sys

def live_academic_forensic_audit(author_query):
    print(f"Initiating Global Academic Discovery Matrix for: {author_query}")
    print("-" * 75)
    
    # OpenAlex API Gateway (Standard JSON engine, no C-compiler needed)
    url_encoded = urllib.parse.quote(author_query)
    target_url = f"https://api.openalex.org/authors?search={url_encoded}"
    
    req = urllib.request.Request(
        target_url, 
        headers={'User-Agent': 'AcademicAuditor/1.0 (mailto:fckrzkill@gmail.com)'}
    )
    
    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode('utf-8'))
            results = data.get("results", [])
            
            if not results:
                print("Alert: Walang nahanap na tugmang digital footprints sa public registry.")
                return
                
            # Kunin ang pinaka-angkop na top matching record match array block
            author_node = results[0]
            print(f"Sovereign Entity Found:  {author_node.get('display_name')}")
            print(f"Last Known Institution:  {author_node.get('last_known_institutions', [{}])[0].get('display_name', 'N/A')}")
            print(f"Works Count (H-Index):   {author_node.get('works_count')}")
            print(f"Total Global Citations:  {author_node.get('cited_by_count')}")
            print("-" * 75)
            
            # Pormal na pag-hila sa huling 3 active publication logs ng entity history matrix
            works_url = author_node.get("works_api_url")
            if works_url:
                print(f"{'Recent Academic Publication Title':<60} | {'Year':<6}")
                print("-" * 75)
                with urllib.request.urlopen(urllib.request.Request(works_url, headers=req.headers)) as works_resp:
                    works_data = json.loads(works_resp.read().decode('utf-8'))
                    for work in works_data.get("results", [])[:3]:
                        title = work.get("title", "Unknown Context")
                        year = work.get("publication_year", "N/A")
                        print(f"{title[:57]:<60} | {year:<6}")
                        
    except Exception as e:
        print(f"Network Ingestion Interruption Logged: {e}")

if __name__ == "__main__":
    # Pwede mong palitan itong parameter string para sa kahit anong author profile testing configurations
    live_academic_forensic_audit("Steven A. Balbus")
