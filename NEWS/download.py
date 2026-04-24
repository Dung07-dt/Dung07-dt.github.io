import urllib.request
import json
import os

base = 'c:/Users/Hi/Documents/GitHub/Dung07-DT.github.io/NEWS'
results = []

# Topics and search queries
topics = [
    ('mbappe.jpg', 'Kylian Mbappé football player'),
    ('real-madrid.jpg', 'Santiago Bernabéu Stadium Real Madrid'),
    ('anfield.jpg', 'Anfield Stadium Liverpool'),
    ('old-trafford.jpg', 'Old Trafford Manchester United'),
    ('camp-nou.jpg', 'Camp Nou Barcelona stadium'),
    ('allianz-arena.jpg', 'Allianz Arena Munich'),
    ('parc-des-princes.jpg', 'Parc des Princes Paris Saint-Germain')
]

for filename, query in topics:
    try:
        # Search Wikimedia Commons
        search_url = 'https://commons.wikimedia.org/w/api.php?action=query&list=search&srsearch=' + urllib.parse.quote(query) + '&srnamespace=6&srlimit=1&format=json'
        with urllib.request.urlopen(search_url, timeout=30) as resp:
            data = json.loads(resp.read().decode())
        
        if not data['query']['search']:
            results.append(f'NO RESULTS: {filename}')
            continue
        
        title = data['query']['search'][0]['title']
        
        # Get image URL
        image_url = 'https://commons.wikimedia.org/w/api.php?action=query&titles=' + urllib.parse.quote(title) + '&prop=imageinfo&iiprop=url|size&format=json'
        with urllib.request.urlopen(image_url, timeout=30) as resp:
            data = json.loads(resp.read().decode())
        
        pages = data['query']['pages']
        page = list(pages.values())[0]
        if 'imageinfo' not in page:
            results.append(f'NO IMAGEINFO: {filename} for {title}')
            continue
        
        direct_url = page['imageinfo'][0]['url']
        
        # Download image
        out_path = os.path.join(base, filename)
        urllib.request.urlretrieve(direct_url, out_path)
        size = os.path.getsize(out_path)
        results.append(f'SUCCESS: {filename} from {title} - {size} bytes')
    except Exception as e:
        results.append(f'FAILED: {filename} - {str(e)}')

# Write log
with open(os.path.join(base, 'download-log.txt'), 'w') as f:
    f.write('\n'.join(results))

