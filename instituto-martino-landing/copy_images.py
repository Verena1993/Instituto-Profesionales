import os
import shutil
import re

# Set up paths
brain_dir = r"C:\Users\USER\.gemini\antigravity\brain\f787f65d-905d-4f9f-bd3c-234ff28c06ae"
project_dir = r"C:\Users\USER\.gemini\antigravity\scratch\instituto-martino-landing"
images_dir = os.path.join(project_dir, "images")
css_dir = os.path.join(project_dir, "css")

# Create directories if they don't exist
os.makedirs(images_dir, exist_ok=True)
os.makedirs(css_dir, exist_ok=True)

print("Project directories created.")

# Map doctor photos
doctors = {
    "media__1779487257993.jpg": "dr-carlos-martino.jpg",
    "media__1779487258006.jpg": "dr-claudio-martino.jpg",
    "media__1779487258020.jpg": "dr-franco-giovannini.jpg"
}

for src_name, dest_name in doctors.items():
    src_path = os.path.join(brain_dir, src_name)
    dest_path = os.path.join(images_dir, dest_name)
    if os.path.exists(src_path):
        shutil.copy(src_path, dest_path)
        print(f"Copied {src_name} to {dest_name}")
    else:
        print(f"Source file not found: {src_path}")

# Scan content.md for image URLs
content_path = os.path.join(brain_dir, ".system_generated", "steps", "10", "content.md")
if os.path.exists(content_path):
    print("\nScanning website content for images and logo...")
    with open(content_path, "r", encoding="utf-8") as f:
        html_content = f.read()
    
    # Search for image tags and URLs
    img_urls = re.findall(r'src="([^"]+)"', html_content)
    srcset_urls = re.findall(r'srcSet="([^"]+)"', html_content)
    
    # Filter unique URLs
    all_urls = set(img_urls)
    for s in srcset_urls:
        all_urls.update([url.strip().split(' ')[0] for url in s.split(',')])
        
    print("Found image URLs on website:")
    for url in sorted(list(all_urls)):
        if "logo" in url.lower() or "martin" in url.lower() or "vector" in url.lower() or "instituto" in url.lower():
            print(f"- {url}")
else:
    print(f"\nWebsite content file not found at {content_path}")
