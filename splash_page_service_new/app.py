#!/usr/bin/env python
import requests
import os
import time
from flask import Flask, abort, request, jsonify, url_for
from flask_sqlalchemy import SQLAlchemy

# initialization
app = Flask(__name__)
app.config['SECRET_KEY'] = 'hello'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite'
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN'] = True
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

base_url = 'https://api.meraki.com/api/v1'

db = SQLAlchemy(app)


class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, index=True)
    router_id = db.Column(db.Integer, index=True)
    brandname = db.Column(db.String(32), index=True)
    api_key = db.Column(db.String(32), index=True)
    org_id = db.Column(db.String(32), index=True)
    org_name = db.Column(db.String(32), index=True)
    network_id = db.Column(db.String(32), index=True)
    network_name = db.Column(db.String(32), index=True)
    ssid_number = db.Column(db.String(32), index=True)
    ssid_name = db.Column(db.String(32), index=True)
    splash_url = db.Column(db.String(32), index=True)


@app.route('/api/users', methods=['POST'])
def new_user():
    user_id = request.json.get('user_id')
    if user_id is None:
        abort(400)    # missing arguments
    if User.query.filter_by(user_id=user_id).first() is not None:
        abort(400)    # existing user
    user = User(user_id=user_id)
    db.session.add(user)
    db.session.commit()
    return (jsonify({'user_id': user.user_id}), 201,
            {'Location': url_for('get_user', id=user.id, _external=True)})


@app.route('/api/users/<int:id>')
def get_user(id):
    user = User.query.get(id)
    if not user:
        abort(400)
    return jsonify({'user_id': user.user_id})


@app.route('/api/router/<user_id>', methods = ['POST']) # set router brand
def set_router_brand(user_id):
    brandname = request.json.get('brandname')
    user = User.query.filter_by(user_id=user_id).first()
    user.brandname = brandname 
    if brandname == 'meraki':
        user.router_id = 1
    db.session.commit()
    return  {
            'brandname': user.brandname,
            'router_id': user.router_id
            }

@app.route('/api/user/<user_id>/config/api', methods = ['POST']) # set api
def set_api(user_id):
    api_key = request.json.get('api_key')
    if api_key is None:
        abort(400) # missing arguments
    if User.query.filter_by(api_key=api_key).first() is not None:
        abort(400)    # existing api_key
    user = User.query.filter_by(user_id=user_id).first()
    user.api_key = api_key
    db.session.commit()
    return (jsonify({'api_key': user.api_key}), 201)

# @app.route('/get_api/<id>')
# def get_api():
#     user = User.query.get(id)
#     if not user:
#         abort(400)
#     return jsonify({'api_key': user.api_key})

@app.route('/api/user/<user_id>/config/organizations', methods = ['POST']) # set orgs
def set_org(user_id):
    org_id = request.json.get('org_id')
    if org_id is None:
        abort(400) # missing arguments
    if User.query.filter_by(org_id=org_id).first() is not None:
        abort(400)    # existing api_key
    user = User.query.filter_by(user_id=user_id).first()
    user.org_id = org_id
    db.session.commit()
    return (jsonify({'org_id': user.org_id}), 201)

@app.route('/api/user/<user_id>/organizations') # get_orgs
def get_org_data_by_api_key(user_id):
    user = User.query.filter_by(user_id=user_id).first()
    if not user:
        abort(400)
    api_key = user.api_key
    org_data = {}
    get_url = f'{base_url}/organizations'
    headers = {'X-Cisco-Meraki-API-Key': api_key, 'Content-Type': 'application/json'}
    response = requests.get(get_url, headers=headers)
    orgs = response.json() if response.ok else response.text
    if response.ok == True:
        org_data['id'] = orgs[0]['id']
        org_data['name'] = orgs[0]['name']
        return {
                'org_id': org_data['id'],
                'org_name': org_data['name']
                }
    else:
        return "Wrong api_key"

@app.route('/api/user/<user_id>/config/networks', methods = ['POST']) # set network
def set_network(user_id):
    network_id = request.json.get('network_id')
    if network_id is None:
        abort(400) # missing arguments
    if User.query.filter_by(network_id = network_id).first() is not None:
        abort(400)    # existing network_id
    user = User.query.filter_by(user_id=user_id).first()
    user.network_id = network_id
    db.session.commit()
    return (jsonify({'network_id': user.network_id}), 201)


@app.route('/api/user/<user_id>/networks', methods = ['GET', 'POST']) # get networks
def get_networks_by_api_key_and_org_id(user_id):
    user = User.query.filter_by(user_id=user_id).first()
    org_id = user.org_id
    api_key = user.api_key
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

@app.route('/api/user/<user_id>/config/ssids', methods = ['POST']) # set ssids
def set_ssid(user_id):
    ssid_number = request.json.get('ssid_number')
    if ssid_number is None:
        abort(400) # missing arguments
    if User.query.filter_by(ssid_number=ssid_number).first() is not None:
        abort(400)    # existing ssid_number
    user = User.query.filter_by(user_id=user_id).first()
    user.ssid_number = ssid_number
    db.session.commit()
    return (jsonify({'ssid_number': user.ssid_number}), 201)


@app.route('/api/user/<user_id>/ssids')  # get ssid_data
def get_ssids(user_id):
    user = User.query.filter_by(user_id= user_id).first()
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

@app.route('/api/user/<user_id>/config/splash_url', methods = ['POST'])
def set_splash_page(user_id):
    splash_url = request.json.get('splash_url')
    if splash_url is None:
        abort(400) # missing arguments
    if User.query.filter_by(splash_url = splash_url).first() is not None:
        abort(400)    # existing splash url
    user = User.query.filter_by(user_id=user_id).first()
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
