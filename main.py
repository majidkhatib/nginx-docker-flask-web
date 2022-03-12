import sqlite3
from flask import Flask, render_template, url_for, request, redirect 
from send_email import send_email


app = Flask(__name__)

def get_db_connection():
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    return conn


@app.route("/")
def hello_world():
    #conn = get_db_connection()
    #posts = conn.execute('SELECT * FROM posts').fetchall()
    #conn.close()
    return render_template('./index.html')


@app.route("/<string:page_name>")
def html_page(page_name):
    return render_template(page_name)


@app.route('/submit_form', methods=['POST', 'GET'])
def submit_form():
    if request.method == 'POST':
        data = request.form.to_dict()
        send_email(data)
        return redirect('/contact_result.html')



if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True, port=80)

