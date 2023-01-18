from flask import Flask, render_template, request, url_for, redirect
from pymongo import MongoClient
from dotenv import load_dotenv
import os, requests

load_dotenv()
app = Flask(__name__)
# client = MongoClient('localhost', 27017, username='root', password='example') #for local testing
client = MongoClient(os.environ.get('MONGODB_URI'))

db = client.flask_db
grades = db.grades

@app.route('/', methods=['GET'])
def index():
    all_grades = grades.find()
    return render_template('index.html', grades=all_grades)

@app.route('/submit', methods=('GET', 'POST'))
def submit():
    if request.method == 'GET':
        return render_template('submit.html')
    if request.method == 'POST':
        name = request.form['name']
        grade = request.form['grade']
        email = request.form['email']
        grades.insert_one({'name': name, 'grade': grade, 'email': email})
        all_grades = grades.find()
        return redirect(url_for('index'))

@app.route('/deleteroute', methods=['GET', 'POST'])
def deleteroute():
    if request.method == 'GET':
        return render_template('delete.html')
    if request.method == 'POST':
        entry = request.form['nametodelete']
        requests.delete(f"http://127.0.0.1:5000/delete/{entry}")
        return redirect(url_for('index'))

@app.route('/delete/<entry>', methods=['DELETE'])
def delete(entry):
    grades.delete_one({'name': entry})
    return "ok"

@app.route('/putroute', methods=['GET', 'POST'])
def putroute():
    if request.method == 'GET':
        return render_template('put.html')
    if request.method == 'POST':
        modifygrade = request.form['modifygrade']
        newgrade = request.form['newgrade']
        requests.put(f"http://127.0.0.1:5000/put/{modifygrade}/{newgrade}")
        return redirect(url_for('index'))

@app.route('/put/<modifygrade>/<newgrade>', methods=['PUT'])
def put(modifygrade, newgrade):
    filter = {'grade': modifygrade}
    newgrade =   {"$set": {"grade": newgrade}}
    grades.update_one(filter, newgrade)
    return "ok"

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)