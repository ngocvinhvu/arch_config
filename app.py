#!/usr/bin/env python
# api_key = "50afdb8906f5b437142bdbf3decc04fce7556b5c"
import requests
import os
import time
from flask import Flask, abort, request, jsonify, url_for
from flask_pymongo import PyMongo

# initialization
app = Flask(__name__)
app.config['SECRET_KEY'] = 'hello'
app.config['MONGO_URI'] = 'mongodb://localhost:27017/wifi'
base_url = 'https://api.meraki.com/api/v1'
mongo = PyMongo(app)

# colList = ['users', 'user_organizations', 'organizations', 'router_organizations', 'routers', 'router_brands', 'router_configurations', 'configurations']

@app.route('/v1/users', methods=['GET', 'POST'])
def user_add():
	user_id = request.json.get('user_id')
	users_cols = mongo.db.users
	user_organizations_cols = mongo.db.user_organizations
	if user_id is None:
		return {"error": 1,
				"msg": "missing user_id arguments"	  # missing arguments
				}
	if users_cols.find_one({"user_id":user_id}) is not None:
		return {
				"error": 1,
				"msg": "existing user_id"	 # existing user
				}
	users_cols.insert({"id": user_id, "status":"active"})
	user_organizations_cols.insert_one({"user_id":user_id, "organization_id":1, "role_name":"admin"})
	return {
			"user_id": user_id,
			"response_code": 201
			}

@app.route('/v1/users/<int:user_id>', methods=['DELETE'])
def user_del(user_id):
	payload = None
	users_cols = mongo.db.users
	# user_orgs_cols = mongo.db.user_organizations
	user = cols.find_one({"id":user_id})
	if not user:
		return {'error':1,
				'msg': f"user_id: {user_id} is not existing"}
	users_cols.delete_one({"id":user_id})
	# user_orgs_cols.delete_one({"user_id":user_id})
	return {'response code':204,
			'msg': f"deleted data of user_id: {user_id}"}

@app.route('/v1/users/<int:user_id>/routers', methods = ['POST']) # set router brand
def router_add(user_id):
	brandname = request.json.get('brand_short_name')
	user = mongo.db.users.find_one({"id":user_id})
	if not user:
		return {
				"error": 404,
				"msg": f"user_id {user_id} is not found"
				}
	routers_cols = mongo.db.routers
	router_configurations_cols = mongo.db.router_configurations
	router_organizations_cols = mongo.db.router_organizations
	if not user:
		return {
				"error": 404,
				"msg": f"user_id {user_id} is not existing"
				}
	if brandname == "meraki" or brandname == "Meraki":
		router_obj = routers_cols.insert_one({"router_brand_id": 1, "user_id":user_id, "status":"active"})
		router_id = str(router_obj.inserted_id)
		routers_cols.update_one({"_id":router_obj.inserted_id}, {"$set": {"id":router_id}})
		router_organizations_cols.insert_one({"router_id":router_id, "organizations_id":1})
		router_configurations_cols.insert_one({"configuration_id":router_id})
	return	{
			"id": router_id,
			"status": "active",
			'router_brand_id': 1,
			}
@app.route('/v1/routers/<router_id>', methods=['DELETE'])
def router_del(router_id):
	routers_cols = mongo.db.routers
	router = routers_cols.find_one({"id": router_id})
	if not router:
		return {
				"error": 404,
				"msg": f"not found router {router_id}"
				}
	routers_cols.delete_one({"id":router_id})
	return {
			"response_code": 204,
			"msg": f"deleted router {router_id}"
			}
	

@app.route('/v1/user_id/<int:user_id>/routers', methods = ['GET'])
def router_list(user_id):
	user = mongo.db.users.find_one({"id":user_id})
	if not user:
		return {
				"error": 404,
				"msg": f"user_id {user_id} is not found"
				}
	routers_cols = mongo.db.routers
	router_brands_cols = mongo.db.router_brands
	routers = routers_cols.find({"user_id":user_id}).toArray()
	router_ids = [routers[i]['id'] for i in range(len(routers))]
	router_brand_ids = [routers[i]['router_brand_id'] for i in range(len(routers))]
	router_brand_names = []
	for i in router_brand_ids:
		if i == 1:
			router_brand_names.append("meraki")
		if i == 2:
			router_brand_names.append("unifi")
	return {
			'response_code': 200,
			'router_list' : dict(zip(router_ids, router_brand_names))
			}


@app.route('/v1/routers/<router_id>/configurations', methods = ['POST']) # set api
def api_key_add(router_id):
	api_key = request.json.get('api_key')
	if api_key is None:
		return {"status": 0,
				"msg": "missing api_key arguument"	# missing arguments
				}
	cols = mongo.db.routers
	cols1 = mongo.db.users
	router = cols.find_one({"user_id":user_id})
	if router.api_key == api_key:
		return {
				"status" : 0,
				"msg": "existing api_key"
				}
	router_id = str(user_id) + "_" + api_key
	cols.update_one({"user_id":user_id}, {"$set":{"api_key": api_key, "router_id": router_id}})
	cols1.update_one({"user_id":user_id}, {"$set":{"router_id": router_id, "data_id": router_id}})
	return (jsonify({'status': 1, 'api_key': api_key}), 201)


@app.route('/api/users/<int:user_id>/api/delete')
def api_del(user_id):
	user = User.query.filter_by(user_id=user_id).first()
	if not user:
		return {'status':0,
				'msg': f"user_id = {user_id} is not existing"}
	if not user.api_key:
		return {'status':0,
				'msg': f"api_key of user_id = {user_id} is not existing"}
	temp_api_key = user.api_key
	user.api_key = None
	db.session.commit()
	return {'status':1,
			'msg': f"deleted api_key: {temp_api_key}"}





@app.route('/api/users/<user_id>/config/organizations', methods = ['POST']) # set orgs
def set_orgs(user_id):
	org_id = request.json.get('org_id')
	if org_id is None:
		return {'status': 0,
				'msg': "missting org_id argument"  # missing arguments
				}
	user = mongo.db.users({"user_id":user_id})
	cols = mongo.db.data
	cols.insert({"user_id": user_id, "org_id": org_id, "data_id": user.data_id})
	return (jsonify({'status': 1, 'org_id': org_id}), 201)

@app.route('/api/users/<user_id>/organizations') # get orgs
def get_orgs(user_id):
	user = mongo.db.users.find_one({"user_id":user_id})
	router = mongo.db.routers.find_one({"router_id":user.router_id})
	if not user:
		return {'status': 0, 
				'msg': "user_id is not exist"
				}
	api_key = router.api_key
	org_data = {}
	get_url = f'{base_url}/organizations'
	headers = {'X-Cisco-Meraki-API-Key': api_key, 'Content-Type': 'application/json'}
	response = requests.get(get_url, headers=headers)
	orgs = response.json() if response.ok else response.text
	if response.ok == True:
		org_data['id'] = orgs[0]['id']
		org_data['name'] = orgs[0]['name']
		return {
				'status': 1,
				'org_id': org_data['id'],
				'org_name': org_data['name']
				}
	else:
		return {'status': 0,
				'msg': "Wrong api_key"
				}

@app.route('/api/users/<user_id>/config/networks', methods = ['POST']) # set network
def set_networks(user_id):
	network_id = request.json.get('network_id')
	if network_id is None:
		return {'status': 0, 
				'msg': "missing network_id argument"  # missing arguments
				}
	user = mongo.db.users.find_one({"user_id":user_id})
	cols = mongo.db.data
	cols.update_one({"data_id":user.data_id},{"$set":{"network_id":network_id}})
	return (jsonify({'status': 1, 'network_id': network_id}), 201)


@app.route('/api/users/<user_id>/networks', methods = ['GET']) # get networks
def get_networks(user_id):
	user = mongo.db.users.find_one({"user_id":user_id})
	router = mongo.db.routers.find_one({"router_id":user.router_id})
	data = mongo.db.data.find_one({"data_id":user.data_id})
	org_id = data.org_id
	api_key = router.api_key
	get_url = f'{base_url}/organizations/{org_id}/networks'
	headers = {'X-Cisco-Meraki-API-Key': api_key, 'Content-Type': 'application/json'}
	response = requests.get(get_url, headers=headers)
	data = response.json() if response.ok else response.text
	network_ids = []
	network_names = []
	for item in data:
		network_ids.append(item['id'])
		network_names.append(item['name'])
	network_data = dict(zip(network_ids, network_names))
	return {
			'status': 1,
			'network_data':network_data
			}

@app.route('/api/users/<user_id>/config/ssids', methods = ['POST']) # set ssids
def set_ssids(user_id):
	ssid_number = request.json.get('ssid_number')
	if ssid_number is None:
		return {'status': 0,
				'msg': "ssid number is missing"  # missing arguments
				}
	user = mongo.db.users.find_one({"user_id":user_id})
	router = mongo.db.routers.find_one({"router_id":user.router_id})
	data = mongo.db.data
	data.update_one({"data_id":user.data_id}, {"$set":{"ssid_number":ssid_number}})
	return (jsonify({'status':1, 'ssid_number': ssid_number}), 201)


@app.route('/api/users/<user_id>/ssids')  # get ssid_data
def get_ssids(user_id):
	user = mongo.db.user.find_one({"user_id":user_id})
	router = mongo.db.routers.find_one({"router_id":user.router_id})
	data = mongo.db.data.find_one({"data_id":user.data_id})
	if not user:
		return {'status':0,
				'msg': f"user_id {user_id} is not existing"
				}
	if not router.api_key:
		return {'status':0,
				'msg': "api_key is not existing"
				}
	network_id =  data.network_id
	headers = {'X-Cisco-Meraki-API-Key': api_key, 'Content-Type': 'application/json'}
	get_url = f"{base_url}/networks/{network_id}/wireless/ssids/"
	response = requests.get(get_url, headers=headers)
	data = response.json() if response.ok else response.text
	ssids_name = list(item['name'] for item in data if "Unconfigured" not in item['name'])
	ssids_number = list(item['number'] for item in data if "Unconfigured" not in item['name']) 
	ssids_data =  dict(zip(ssids_number, ssids_name))
	return {'status': 1,
			'ssids_data': ssids_data
			}
@app.route('/api/users/<int:user_id>/networks/<network_id>/ssids/<ssid_number>/get_limit')
def get_limit(user_id, network_id, ssid_number):
	user = mongo.db.users.find_one({"user_id":user_id})
	router = mongo.db.routers.find_one({"router_id":user.router_id})
	api_key = router.api_key
	url = f"https://api.meraki.com/api/v1/networks/{network_id}/wireless/ssids/{ssid_number}"
	
	payload = None
	
	headers = {
		"Content-Type": "application/json",
		"Accept": "application/json",
		"X-Cisco-Meraki-API-Key": api_key
	}
	response = requests.request('GET', url, headers=headers, data = payload)
	data = response.json()
	return {
			'status' : 1,
			# "perClientBandwidthLimitDown": data['perClientBandwidthLimitDown'], 
			# "perClientBandwidthLimitUp": data['perClientBandwidthLimitUp'], 
			"perSsidBandwidthLimitDown": data['perSsidBandwidthLimitDown'], 
			"perSsidBandwidthLimitUp": data['perSsidBandwidthLimitUp'], 
			# "splashTimeout": data['splashTimeout'],
			}

@app.route('/api/users/<int:user_id>/networks/<network_id>/ssids/<ssid_number>/get_splash_timeout')
def get_splash_timeout(user_id, network_id, ssid_number):
	user = mongo.db.users.find_one({"user_id":user_id})
	router = mongo.db.routers.find_one({"router_id":user.router_id})
	api_key = router.api_key
	url = f"https://api.meraki.com/api/v1/networks/{network_id}/wireless/ssids/{ssid_number}/splash/settings"
	payload = None
	headers = {
		"Content-Type": "application/json",
		"Accept": "application/json",
		"X-Cisco-Meraki-API-Key": api_key
	}
	response = requests.request('GET', url, headers=headers, data = payload)
	data = response.json()
	return {
			'status' : 1,
			"splashTimeout": data['splashTimeout'],
			}


@app.route('/api/users/<int:user_id>/ssids/limit', methods=['POST'])
def set_limit(user_id):
	user = mongo.db.users.find_one({"user_id":user_id})
	if not user:
		return {
				'status': 0,
				'msg': f"user_id {user_id} is not existing"
				}
	router = mongo.db.users.find_one({"router_id":user.router_id})
	api_key = router.api_key
	network_id = request.json.get('network_id')
	if not network_id:
		return {
				'status': 0,
				'msg': "network_id is missing"
				}
	number = request.json.get('ssid_number')
	if not number:
		return {
				'status': 0,
				'msg': "ssid_number is missing"
				}
	limit_up = request.json.get('limit_up')
	if not limit_up:
		return {
				'status': 0,
				'msg': "limit_up is missing"
				}
	limit_down = request.json.get('limit_down')
	if not limit_down:
		return {
				'status': 0,
				'msg': "limit_down is missing"
				}
	cols = mongo.db.data
	put_url = f"https://api.meraki.com/api/v1/networks/{network_id}/wireless/ssids/{number}"
	response = requests.put(
			put_url,
			headers={
				"X-Cisco-Meraki-API-Key": api_key,
				"Content-Type": "application/json",
				},
			json={
				# "perClientBandwidthLimitUp": int(limit_up),
				# "perClientBandwidthLimitDown": int(limit_down),
				"perSsidBandwidthLimitUp": int(limit_up),
				"perSsidBandwidthLimitDown": int(limit_down),
				# "splashTimeout": splash_timeout,
				},
			)
	return {
			'status': 1,
			'network_id': network_id,
			'ssid_number': number,
			'limit_up': limit_up,
			'limit_down': limit_down,
			# 'splashTimeout': splash_timeout,
			}



@app.route('/api/users/<user_id>/config/splash_url', methods = ['POST'])
def set_splash_url(user_id):
	splash_url = request.json.get('splash_url')
	if splash_url is None:
		return {'status': 0,
				'msg': "missing splash_url argument"  # missing arguments
				}
	user = mongo.db.users.find_one({"user_id":user_id})
	router = mongo.db.users.find_one({"router_id":user.router_id})
	cols = mongo.db.data
	cols.update({"data_id":user.data_id}, {"$set":{"splash_url":splash_url}})
	data = cols.find_one({"data_id":user.data_id})
	api_key = router.api_key
	network_id = data.network_id
	number = data.ssid_number

	put_url = f"{base_url}/networks/{network_id}/wireless/ssids/{number}/splash/settings"

	response = requests.put(
			put_url,
			headers={
				"X-Cisco-Meraki-API-Key": api_key,
				"Content-Type": "application/json",
				},
			json={
				"splashPage": "Click-through splash page",
				"splashUrl": splash_url,
				"useCustomUrl": True
				},
			)
	return {'status': 1,
			'splash_url': splash_url}


if __name__ == '__main__':
	mongo.init_app(app)
	app.run(debug=True)
