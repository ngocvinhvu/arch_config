from flask import Flask, json, redirect, render_template, request, flash, session
import requests

app = Flask(__name__)
app.secret_key = 'hello'
# api_key = "50afdb8906f5b437142bdbf3decc04fce7556b5c"
# api_key = ""
org_data = {
		'name':'',
		'id':''
		}
network_data = {}
base_url = 'https://api.meraki.com/api/v1'


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
		session['org_data'] = org_data
		return	render_template('get_orgs.html', org_name = session['org_data']['name'], org_id = session['org_data']['id'])
	else:
		return "Cannot get the response"
	# (True, [{'id': '111353', 'name': 'VC Corporation', 'url': 'https://n17.meraki.com/o/o39y0b/manage/organization/overview'}])

@app.route('/get_networks', methods = ['GET', 'POST'])
def get_networks():
	# org_id = session['org_data']['id']
	org_id = request.form['org_id']
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
	ssids = {}
	for key in session['network_data'].keys():
		get_url = f'{base_url}/networks/{key}/wireless/ssids/'
		response = requests.get(get_url, headers=headers)
		data = response.json() if response.ok else response.text
		ssids[session['network_data'][key]] = list(item['name'] for item in data if "Unconfigured" not in item['name'])
	session['ssids'] = ssids
	return session['ssids'] 
	# return render_template('get_splash_settings', network_data = session['ssids'])

@app.route('/get_splash_settings')
def get_splash_settings():
	headers = {'X-Cisco-Meraki-API-Key': session['api_key'], 'Content-Type': 'application/json'}
# 	network_ids = list(session['network_data'].keys())
# 	network_names = list(session['network_data'].values())
# 	nums_ssid = list((list(range(len(ssid))) for ssid in (session['ssids'].values())))
# 	num_ssids_of_network_by_id = dict(zip(network_ids, nums_ssid))
# 	num_ssids_of_network_by_name = dict(zip(network_names, nums_ssid))
	network_id = request.form['network_id']
	number = requeset.form['number']
	get_url = f"{base_url}/networks/{network_id}/wireless/ssids/{number}/splash/settings"
	response = requests.get(get_url, headers=headers)
	data = response.json() if response.ok else response.text
	# for network_id in network_ids:
	# 	for ssid in session['ssids'].values():
	# 		get_url = f'{base_url}/networks/{network_id}/wireless/ssids/{network.index(number)}/splash/settings'
	# 		response = requests.get(get_url, headers=headers)
	# 		data = response.json() if response.ok else response.text
	# 		splash_settings[number] = data
	# session['splash_settings'] = splash_settings
	# return session['splash_settings']
	return num_ssids_of_network_by_name

@app.route('/splash_page_config')
def splash_page_config():
	pass



if __name__ == "__main__":
	app.run(debug=True)
