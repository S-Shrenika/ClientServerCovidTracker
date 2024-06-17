from flask import Flask, request, jsonify
import requests
from datetime import datetime, timedelta

app = Flask(__name__)

# Endpoint to get Arizona COVID data for the last 7 days
@app.route('/api/arizona', methods=['GET'])
def get_arizona_data():
    response = requests.get('https://api.covidtracking.com/v1/states/az/daily.json')
    data = response.json()

    last_7_days = data[:7]
    result = [{'date': entry['date'], 'positive': entry['positive'], 'negative': entry['negative']} for entry in last_7_days]

    return jsonify(result)

# Endpoint to get COVID data for a specific state and date range
@app.route('/api/state', methods=['POST'])
def get_state_data():
    content = request.json
    state = content['state']
    start_date = datetime.strptime(content['start_date'], '%Y-%m-%d')
    end_date = datetime.strptime(content['end_date'], '%Y-%m-%d')

    response = requests.get(f'https://api.covidtracking.com/v1/states/{state.lower()}/daily.json')
    data = response.json()

    filtered_data = []
    for entry in data:
        entry_date = datetime.strptime(str(entry['date']), '%Y%m%d')
        if start_date <= entry_date <= end_date:
            filtered_data.append({'date': entry['date'], 'positive': entry['positive'], 'negative': entry['negative']})

    return jsonify(filtered_data)

if __name__ == '__main__':
    app.run(debug=True)
