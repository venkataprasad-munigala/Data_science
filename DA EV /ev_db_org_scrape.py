import requests
from bs4 import BeautifulSoup
import pandas as pd

ev_dict = {}
ev_names = []
ev_models = []
ev_subtitles = []
ev_accelerations = []
ev_top_speeds = []
ev_ranges = []
ev_efficiencys = []
ev_fast_charge_speeds = []
ev_drive_types = []
ev_number_of_seats = []
ev_germany_prices = []
ev_uk_prices = []

Endpoint = "https://ev-database.org"
response = requests.get(Endpoint).text
soup = BeautifulSoup(response, "html.parser")
# print(soup)
all_evs = soup.select('div.list-item')
for ev in all_evs:
    # fetch name and model
    a_tag = ev.find('a', class_='title')
    span = a_tag.findAll('span')
    name = span[0].text.strip()
    model = span[1].text.strip()
    ev_names.append(name if name != '' else ' ')
    ev_models.append(model if model != '' else ' ')

    # fetch subtitle
    subtitle_div = ev.find('div', class_='subtitle')
    subtitle = subtitle_div.text.strip()
    ev_subtitles.append(subtitle if subtitle != '' else ' ')

    # fetch specs
    acceleration = ev.find('span', class_='acceleration').text.strip()
    ev_accelerations.append(acceleration if acceleration != '' else ' ')

    top_speed = ev.find('span', class_='topspeed').text.strip()
    ev_top_speeds.append(top_speed if top_speed != '' else ' ')

    range = ev.find('span', class_='erange_real').text.strip()
    ev_ranges.append(range if range != '' else ' ')

    efficiency = ev.find('span', class_='efficiency').text.strip()
    ev_efficiencys.append(efficiency if efficiency != '' else ' ')

    fast_charge_speed = ev.find('span', class_='fastcharge_speed_print').text.strip()
    ev_fast_charge_speeds.append(fast_charge_speed if fast_charge_speed != '' else ' ')

    seats = ev.findAll('span', title='Number of seats')
    number_of_seats = seats[1].text.strip()
    ev_number_of_seats.append(number_of_seats if number_of_seats != '' else ' ')

    germany_price = ev.find('span', class_='country_de').text.strip()
    ev_germany_prices.append(germany_price if germany_price != '' else ' ')

    uk_price = ev.find('span', class_='country_uk').text.strip()
    ev_uk_prices.append(uk_price if uk_price != '' else ' ')

    # fetch drive type
    icon_div = ev.find('div', class_='icons')
    icon_spans = icon_div.findAll('span')
    for span_tag in icon_spans:
        title_attribute = span_tag.get('title', 'None')
        if "Drive" in title_attribute:
            drive = title_attribute
    ev_drive_types.append(drive if drive != '' else ' ')

ev_dict = {
    "Name": ev_names,
    "Model": ev_models,
    "Subtitle": ev_subtitles,
    "Acceleration": ev_accelerations,
    "Top_Speed": ev_top_speeds,
    "Range": ev_ranges,
    "Efficiency": ev_efficiencys,
    "Fast_Charge": ev_fast_charge_speeds,
    "Drive_Type": ev_drive_types,
    "No_Of_Seats": ev_number_of_seats,
    "Germany_Price": ev_germany_prices,
    "UK_Price": ev_uk_prices
}
df = pd.DataFrame(ev_dict)
df.to_csv('./EV_database_org.csv', index=False)
