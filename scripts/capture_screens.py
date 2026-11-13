import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--window-size=430,932')
options.add_argument('--force-device-scale-factor=2')

driver = webdriver.Chrome(options=options)
try:
    # 1. Capture Home Rider Map
    driver.get('http://127.0.0.1:5000/index.html')
    time.sleep(4)
    driver.save_screenshot('C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/map_home_rider.png')
    print('Home map captured.')

    # 2. Capture Active Trip Map
    driver.execute_script("showScreen('screen-active-trip');")
    time.sleep(3)
    driver.save_screenshot('C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/map_active_trip.png')
    print('Active trip map captured.')

    # 3. Capture Driver Cockpit Demand Heatmap
    driver.execute_script("showScreen('screen-driver-cockpit');")
    time.sleep(3)
    driver.save_screenshot('C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/map_driver_cockpit.png')
    print('Driver cockpit map captured.')

finally:
    driver.quit()
print('ALL SCREENSHOTS CAPTURED SUCCESSFULLY!')

