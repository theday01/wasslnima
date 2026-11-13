import os
from PIL import Image, ImageDraw, ImageFont

def generate_app_icon(output_path, is_driver=False):
    sizes = [
        ('mipmap-mdpi', 48),
        ('mipmap-hdpi', 72),
        ('mipmap-xhdpi', 96),
        ('mipmap-xxhdpi', 144),
        ('mipmap-xxxhdpi', 192),
    ]
    
    for folder, size in sizes:
        dir_path = os.path.join(output_path, folder)
        os.makedirs(dir_path, exist_ok=True)
        img_path = os.path.join(dir_path, 'ic_launcher.png')
        
        # High-res base for smooth antialiasing
        scale = 4
        base_size = size * scale
        img = Image.new('RGBA', (base_size, base_size), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)
        
        # Background: Moroccan Emerald or Gold-accented
        # Rider: Emerald #0D3E30, Driver: Deep Night #091C15 with Gold Crown
        bg_color = (13, 62, 48, 255) if not is_driver else (9, 28, 21, 255)
        gold_color = (212, 175, 55, 255)
        white_color = (255, 255, 255, 255)
        
        # Rounded squircle
        radius = int(base_size * 0.24)
        draw.rounded_rectangle([(0, 0), (base_size, base_size)], radius=radius, fill=bg_color)
        
        # Inner Gold Border
        border_inset = int(base_size * 0.04)
        border_width = int(base_size * 0.03)
        draw.rounded_rectangle(
            [(border_inset, border_inset), (base_size - border_inset, base_size - border_inset)],
            radius=radius - border_inset,
            outline=gold_color,
            width=border_width
        )
        
        # Draw Taxi / Car Silhouette
        cx = base_size // 2
        cy = int(base_size * 0.48)
        car_w = int(base_size * 0.60)
        car_h = int(base_size * 0.35)
        
        # Car body polygon
        roof_w = int(car_w * 0.55)
        roof_y = cy - car_h // 2
        base_y = cy + car_h // 2
        
        car_points = [
            (cx - roof_w // 2, roof_y),
            (cx + roof_w // 2, roof_y),
            (cx + car_w // 2, cy),
            (cx + car_w // 2, base_y),
            (cx - car_w // 2, base_y),
            (cx - car_w // 2, cy),
        ]
        draw.polygon(car_points, fill=gold_color)
        
        # Windshield
        win_w = int(roof_w * 0.85)
        win_top = roof_y + int(car_h * 0.12)
        win_bot = cy
        win_points = [
            (cx - win_w // 2, win_top),
            (cx + win_w // 2, win_top),
            (cx + int(car_w * 0.38), win_bot),
            (cx - int(car_w * 0.38), win_bot),
        ]
        draw.polygon(win_points, fill=bg_color)
        
        # Headlights
        hl_r = int(base_size * 0.035)
        hl_y = int(cy + car_h * 0.28)
        draw.ellipse([(cx - int(car_w * 0.38) - hl_r, hl_y - hl_r), (cx - int(car_w * 0.38) + hl_r, hl_y + hl_r)], fill=white_color)
        draw.ellipse([(cx + int(car_w * 0.38) - hl_r, hl_y - hl_r), (cx + int(car_w * 0.38) + hl_r, hl_y + hl_r)], fill=white_color)
        
        # Taxi Top Crown Light / Star
        crown_w = int(base_size * 0.16)
        crown_h = int(base_size * 0.06)
        draw.rounded_rectangle(
            [(cx - crown_w // 2, roof_y - crown_h - int(base_size * 0.01)), (cx + crown_w // 2, roof_y)],
            radius=int(crown_h * 0.3),
            fill=white_color
        )
        
        # Distinct Captain / Driver badge (Star icon or Steering indicator)
        if is_driver:
            # Gold star at bottom
            star_y = int(base_size * 0.78)
            draw.text((cx, star_y), "CAPTAIN", fill=gold_color, anchor="mm")
        
        # Resize down to target mipmap with Lanczos antialiasing
        final_img = img.resize((size, size), Image.Resampling.LANCZOS)
        final_img.save(img_path, 'PNG')
        print(f"Created: {img_path} ({size}x{size})")

if __name__ == '__main__':
    base_dir = r"d:\scripts\19- like_IN-Driver"
    rider_res = os.path.join(base_dir, "apps", "rider-app", "android", "app", "src", "main", "res")
    driver_res = os.path.join(base_dir, "apps", "driver-app", "android", "app", "src", "main", "res")
    
    print("Generating Rider App Icons...")
    generate_app_icon(rider_res, is_driver=False)
    
    print("\nGenerating Driver App Icons...")
    generate_app_icon(driver_res, is_driver=True)
    print("\nDone!")

