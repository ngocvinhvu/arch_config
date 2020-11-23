from flask import Flask, redirect, url_for, request, render_template, make_response, escape, session, abort, get_flashed_messages, flash
from werkzeug.utils import secure_filename
import os
from flask_mail import Mail, Message
from flask_wtf import Form
from wtforms import TextField, IntegerField, TextAreaField, SubmitField, RadioField, SelectField

class ContactForm(Form):
	name = TextField("Name Of Students")

app = Flask(__name__)
app.secret_key = 'hello'
app.config['UPLOAD_FOLDER'] = os.getcwd()+"/uploads"
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = 'nnd58xe1@gmail.com'
app.config['MAIL_PASSWORD'] = ''
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True
mail = Mail(app)

@app.route('/contract')
def contact():
	form = ContactForm()
	return render_template('contact.html', form = form)

@app.route('/sendmail')
def sendmail():
	msg = Message("Hello",
			sender="nnd58xe1@gmail.com", 
			recipients=["hotboyarsenal@gmail.com"]
			)
	msg.body = "testing"
	msg.html = "<b>testing</b>"
	mail.send(msg)
	return "sent"

@app.route('/')
def index():
	if 'username' in session:
		username = session['username']
		return 'Logged in as ' + username + '<br>' + \
         "<b><a href = '/logout'>click here to log out</a></b>"
	return "You are not logged in <br><a href = '/login'></b>" + \
"click here to log in</b></a>"

@app.route('/login', methods= ['POST', 'GET'])
def login():
	if request.method == 'POST':
		if request.form['username'] in ["duy", "admin"]:
			session['username'] = request.form['username']
			flash("You are login succesful")
			return redirect(url_for('index'))
		else:
			flash("You are logged in failed")
			return redirect(url_for('index'))
	return '''
	<form action = "" method = "post">
		<p>username:</p>
		<p><input type = "text" name = "username"/></p>
		<p<<input type = "submit" value = "Login"/></p>
	</form>
	
   '''
@app.route('/logout')
def logout():
	session.pop('username', None)
	return redirect(url_for('index'))



@app.route('/setcookie', methods = ['POST', 'GET'])
def setcookie():
	if request.method == 'POST':
		user = request.form['nm']
		resp = make_response(render_template('readcookie.html'))
		resp.set_cookie('userID', user)
		return resp
@app.route('/getcookie')
def getcookie():
	name = request.cookies.get('userID')
	return '<h1>Welcome ' + name + '</h1>'

@app.route('/upload')
def upload():
	return render_template('upload.html')

@app.route('/uploader', methods = ['POST', 'GET'])
def upload_file():
	if request.method == "POST":
		f = request.files['file']
		f.save(os.path.join(app.config['UPLOAD_FOLDER'], secure_filename(f.filename)))
		return "file uploaded successfully"

@app.route('/admin')
def hello_admin():
	return "Hello, admin"

@app.route('/guest/<guest>')
def hello_guest(guest):
	return f"Hello, {guest}"

@app.route('/user/<name>')
def hello_user(name):
	if name == "admin":
		return redirect(url_for("hello_admin"))
	else:
		return redirect(url_for("hello_guest", guest=name))

@app.route('/blog/<int:blogid>/')
def hello_world(blogid):
	return "This is blog %d" % blogid

# @app.route('/student')
# def student():
# 	return render_template('student.html')
# 
# @app.route('/result', methods = ['POST', 'GET'])
# def result():
# 	if request.method == "POST":
# 		result = request.form
# 		return render_template('result.html', result=result)


if __name__ == '__main__':
	# app.debug = True
	# app.run()
	app.run(debug=True) # app.run(host, port, debug, options)
