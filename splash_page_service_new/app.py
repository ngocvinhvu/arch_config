#!/usr/bin/env python
# from flask import Flask, json, redirect, render_template, request, flash, session
import requests
import os
import time
from flask import Flask, abort, request, jsonify, g, url_for, session
from flask_sqlalchemy import SQLAlchemy
from flask_httpauth import HTTPBasicAuth
import jwt
from werkzeug.security import generate_password_hash, check_password_hash

# initialization
app = Flask(__name__)
app.config['SECRET_KEY'] = 'hello'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite'
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN'] = True
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

base_url = 'https://api.meraki.com/api/v1'


# extensions
db = SQLAlchemy(app)
auth = HTTPBasicAuth()


class User(db.Model):
	__tablename__ = 'users'
	id = db.Column(db.Integer, primary_key=True)
	username = db.Column(db.String(32), index=True)
	password_hash = db.Column(db.String(128))
	api_key = db.Column(db.String(32), index=True)
	org_id = db.Column(db.String(32), index=True)
	org_name = db.Column(db.String(32), index=True)
	network_id = db.Column(db.String(32), index=True)
	network_name = db.Column(db.String(32), index=True)
	ssid_number = db.Column(db.String(32), index=True)
	ssid_name = db.Column(db.String(32), index=True)
	splash_url = db.Column(db.String(32), index=True)

	def hash_password(self, password):
		self.password_hash = generate_password_hash(password)

	def verify_password(self, password):
		return check_password_hash(self.password_hash, password)

	def generate_auth_token(self, expires_in=600):
		return jwt.encode(
			{'id': self.id, 'exp': time.time() + expires_in},
			app.config['SECRET_KEY'], algorithm='HS256')

	@staticmethod
	def verify_auth_token(token):
		try:
			data = jwt.decode(token, app.config['SECRET_KEY'],
							  algorithms=['HS256'])
		except:
			return
		return User.query.get(data['id'])
# class Config(db.Model):
#	__tablename__ = 'configs'
#	id = db.Column(db.Integer, primary_key=True)
#	username = db.Column(db.String(32), index=True)
#	api_key = db.Column(db.String(32), index=True)
#	org_id = db.Column(db.String(32), index=True)
#	network_id = db.Column(db.String(32), index=True)
#	ssid_number = db.Column(db.String(32), index=True)

@auth.verify_password
def verify_password(username_or_token, password):
	# first try to authenticate by token
	user = User.verify_auth_token(username_or_token)
	if not user:
		# try to authenticate with username/password
		user = User.query.filter_by(username=username_or_token).first()
		if not user or not user.verify_password(password):
			return False
	g.user = user
	return True


@app.route('/api/users', methods=['POST'])
def new_user():
	username = request.json.get('username')
	password = request.json.get('password')
	if username is None or password is None:
		abort(400)	  # missing arguments
	if User.query.filter_by(username=username).first() is not None:
		abort(400)	  # existing user
	user = User(username=username)
	user.hash_password(password)
	db.session.add(user)
	db.session.commit()
	return (jsonify({'username': user.username}), 201,
			{'Location': url_for('get_user', id=user.id, _external=True)})


@app.route('/api/users/<int:id>')
def get_user(id):
	user = User.query.get(id)
	if not user:
		abort(400)
	return jsonify({'username': user.username})


#####

# api_key = "50afdb8906f5b437142bdbf3decc04fce7556b5c"
# api_key = ""
# org_data = {}
# network_data = {}
# network = ""
# network_id = ""
# network_name = ""



@app.route('/set_api/<username>', methods = ['POST'])
def set_api(username):
	api_key = request.json.get('api_key')
	if api_key is None:
		abort(400) # missing arguments
	if User.query.filter_by(api_key=api_key).first() is not None:
		abort(400)	  # existing api_key
	user = User.query.filter_by(username=username).first()
	user.api_key = api_key
	db.session.commit()
	return (jsonify({'api_key': user.api_key}), 201,
			{'Location': url_for('get_api', id=user.id, _external=True)})

@app.route('/get_api/<id>')
def get_api():
	user = User.query.get(id)
	if not user:
		abort(400)
	return jsonify({'api_key': user.api_key})

@app.route('/set_org/<username>', methods = ['POST'])
def set_org(username):
	org_id = request.json.get('org_id')
	if org_id is None:
		abort(400) # missing arguments
	if User.query.filter_by(org_id=org_id).first() is not None:
		abort(400)	  # existing api_key
	user = User.query.filter_by(username=username).first()
	user.org_id = org_id
	db.session.commit()
	return (jsonify({'org_id': user.org_id}), 201,
			{'Location': url_for('get_org', id=user.id, _external=True)})

@app.route('/get_orgs/<api_key>')
def get_org_data_by_api_key(api_key):
	org_data = {}
	get_url = f'{base_url}/organizations'
	headers = {'X-Cisco-Meraki-API-Key': api_key, 'Content-Type': 'application/json'}
	response = requests.get(get_url, headers=headers)
	orgs = response.json() if response.ok else response.text
	if response.ok == True:
		org_data['name'] = orgs[0]['name']
		org_data['id'] = orgs[0]['id']
		org_data = {
				'name': org_data['name'],
				'id': org_data['id']
				}
		return org_data
	else:
		return "Wrong api_key"
	# (True, [{'id': '111353', 'name': 'VC Corporation', 'url': 'https://n17.meraki.com/o/o39y0b/manage/organization/overview'}])

@app.route('/get_org/<id>')
def get_org():
	user = User.query.get(id)
	if not user:
		abort(400)
	return jsonify({'org_id': user.org_id})

@app.route('/set_network/<username>', methods = ['POST'])
def set_network(username):
	network_id = request.json.get('network_id')
	if network_id is None:
		abort(400) # missing arguments
	if User.query.filter_by(network_id = network_id).first() is not None:
		abort(400)	  # existing network_id
	user = User.query.filter_by(username=username).first()
	user.network_id = network_id
	db.session.commit()
	return (jsonify({'network_id': user.network_id}), 201,
			{'Location': url_for('get_network', id=user.id, _external=True)})

@app.route('/get_network/<id>')
def get_network():
	user = User.query.get(id)
	if not user:
		abort(400)
	return jsonify({'network_id': user.network_id})

@app.route('/get_networks/<api_key>/<org_id>', methods = ['GET', 'POST'])
def get_networks_by_api_key_and_org_id(api_key, org_id):
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
	return network_data

@app.route('/set_ssid/<username>', methods = ['POST'])
def set_ssid(username):
	ssid_number = request.json.get('ssid_number')
	if ssid_number is None:
		abort(400) # missing arguments
	if User.query.filter_by(ssid_number= ssid_number).first() is not None:
		abort(400)	  # existing ssid_number
	user = User.query.filter_by(username=username).first()
	user.ssid_number = ssid_number
	db.session.commit()
	return (jsonify({'ssid_number': user.ssid_number}), 201,
			{'Location': url_for('get_ssid', id=user.id, _external=True)})

@app.route('/get_ssid/<id>')
def get_ssid():
	user = User.query.get(id)
	if not user:
		abort(400)
	return jsonify({'ssid_number': user.ssid_number})


@app.route('/get_ssids/<network_id>', methods = ['GET', 'POST'])
def get_ssids(network_id):
	user = User.query.filter_by(network_id = network_id).first()
	api_key = user.api_key
	network_id =  user.network_id
	headers = {'X-Cisco-Meraki-API-Key': api_key, 'Content-Type': 'application/json'}
	get_url = f"{base_url}/networks/{network_id}/wireless/ssids/"
	response = requests.get(get_url, headers=headers)
	data = response.json() if response.ok else response.text
	ssids_name = list(item['name'] for item in data if "Unconfigured" not in item['name'])
	ssids_number = list(item['number'] for item in data if "Unconfigured" not in item['name']) 
	ssids_data =  dict(zip(ssids_number, ssids_name))
	return ssids_data

@app.route('/set_splash_page/<username>', methods = ['GET', 'POST'])
def set_splash_page(username):
	global captive_portal_base_url
	splash_url = request.json.get('splash_url')
	if splash_url is None:
		abort(400) # missing arguments
	if User.query.filter_by(splash_url = splash_url).first() is not None:
		abort(400)	  # existing splash url
	user = User.query.filter_by(username=username).first()
	user.splash_url = splash_url
	api_key = user.api_key
	network_id = user.network_id
	number = user.ssid_number
	db.session.commit()

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
	return {'splash_url': user.splash_url}



if __name__ == '__main__':
	if not os.path.exists('db.sqlite'):
		db.create_all()
	app.run(debug=True)
