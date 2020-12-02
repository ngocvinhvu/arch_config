from flask import Flask, json, redirect, render_template, request, flash, session
import requests

app = Flask(__name__)
app.secret_key = 'hello'
org_data = {
        'name':'',
        'id':''
        }
network_data = {}
base_url = 'https://api.meraki.com/api/v1'
captive_portal_base_url = "http://103.109.43.160:5000"


@app.route('/')
def index():
    return render_template('get_api_key.html')
@app.route('/get_api_key', methods = ['GET', 'POST'])
def get_api_key():
    global api_key
    if request.method == 'POST' and request.form['api_key'] != '':
        session['api_key'] = request.form['api_key']
        return "Enter API susscessfully. <p>Select Organization: <a href='/get_orgs'>Click here</a></p>"
    else:
        flash("Wrong API key, re-enter")
        return render_template('get_api_key.html')

@app.route('/get_orgs', methods = ['GET', 'POST'])
def get_user_orgs():
    global org_data
    get_url = f'{base_url}/organizations'
    headers = {'X-Cisco-Meraki-API-Key': session['api_key'], 'Content-Type': 'application/json'}

    response = requests.get(get_url, headers=headers)
    orgs = response.json() if response.ok else response.text
    if response.ok == True:
        org_data['name'] = orgs[0]['name']
        org_data['id'] = orgs[0]['id']
        session['org_id'] = org_data['id']
        session['org_name'] = org_data['name']
        session['org_data'] = org_data
        return  render_template('get_orgs.html', org_name = session['org_name'], org_id = session['org_id'])
    else:
        return "Cannot get the response"
    # (True, [{'id': '111353', 'name': 'VC Corporation', 'url': 'https://n17.meraki.com/o/o39y0b/manage/organization/overview'}])

@app.route('/get_networks', methods = ['GET', 'POST'])
def get_networks():
    org_id = request.form['org_id'] if request.method == 'POST' else session['org_id']
    get_url = f'{base_url}/organizations/{org_id}/networks'
    headers = {'X-Cisco-Meraki-API-Key': session['api_key'], 'Content-Type': 'application/json'}
    response = requests.get(get_url, headers=headers)
    data = response.json() if response.ok else response.text
    network_ids = []
    network_names = []
    for item in data:
        network_ids.append(item['id'])
        network_names.append(item['name'])
    network_data = dict(zip(network_ids, network_names))
    session['network_data'] = network_data
    return render_template('get_networks.html', network_data = session['network_data'])

@app.route('/get_ssids', methods = ['GET', 'POST'])
def get_ssid():
    headers = {'X-Cisco-Meraki-API-Key': session['api_key'], 'Content-Type': 'application/json'}
    network_ids = list(session['network_data'].keys())
    if request.method == 'POST':
        network_id = request.form['network_id']
        session['network_id'] = network_id
    else:
        network_id =  session['network_id']
    get_url = f"{base_url}/networks/{network_id}/wireless/ssids/"
    response = requests.get(get_url, headers=headers)
    data = response.json() if response.ok else response.text
    ssids_name = list(item['name'] for item in data if "Unconfigured" not in item['name'])
    ssids_number = list(item['number'] for item in data if "Unconfigured" not in item['name']) 
    ssids_data =  dict(zip(ssids_number, ssids_name))
    session['ssids_data'] = ssids_data

    # for key in session['network_data'].keys():
    #   get_url = f'{base_url}/networks/{key}/wireless/ssids/'
    #   response = requests.get(get_url, headers=headers)
    #   data = response.json() if response.ok else response.text
    #   ssids[session['network_data'][key]] = list(item['name'] for item in data if "Unconfigured" not in item['name'])
    # session['ssids'] = ssids
    # return session['ssids']
    return render_template('get_ssids.html', ssids_data = session['ssids_data'])
    # return ssids_data

@app.route('/get_splash_settings', methods = ['GET', 'POST'])
def get_splash_settings():
    headers = {'X-Cisco-Meraki-API-Key': session['api_key'], 'Content-Type': 'application/json'}
    network_id = session['network_id']
    if request.method == 'POST':
        number = request.form['number']
        session['number'] = number
    else:
        number = session['number']
    get_url = f"{base_url}/networks/{network_id}/wireless/ssids/{number}/splash/settings"
    response = requests.get(get_url, headers=headers)
    data = response.json() if response.ok else response.text
    return f"<h1>Your splash page config</h1> {data} \
            <p>Do you want to change the config: <a href='/splash_page_config'>Settings</a></p>"

@app.route('/splash_page_config', methods = ['GET', 'POST'])
def splash_page_config():
    global captive_portal_base_url
    network_id = session['network_id']
    if request.method == 'POST':
        number = request.form['number']
    else:
        number = session['number']
    put_url = f"{base_url}/networks/{network_id}/wireless/ssids/{number}/splash/settings"
    response = requests.put(
            put_url,
            headers={
                "X-Cisco-Meraki-API-Key": session['api_key'],
                "Content-Type": "application/json",
                },
            json={
                "splashPage": "Click-through splash page",
                "splashUrl": captive_portal_base_url,
                "useCustomUrl": True
                },
            )
    return {'a': response.json()}



if __name__ == "__main__":
    app.run(debug=True)
