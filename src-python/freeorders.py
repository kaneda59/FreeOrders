import api as api
import vat as vat
import os


from flask import Flask, flash, render_template, request, session, abort

app = Flask(__name__)

@app.route("/")
def index():
	words = request.base_url 
	return render_template('index.html', title = "welcome", words=words)

@app.route("/vat")
def login():
    the_api = api.api()
    vats = the_api.getListVat()
    print(vats)
    return render_template("showvat.html", title="liste tvas", vats=vats)

@app.route("/traitment", methods=["POST"])
def traitment():    
    the_api = api.api()   
    tva = the_api.getVat(request.form.get('ID'))    
    return render_template("setvat.html", title="TVA", tva=tva)

@app.route("/saivat", methods=["POST"])
def saivat():
    the_api = api.api()
    tva = vat.vat()
    tva._id = request.form.get('ID')
    tva._label = request.form.get('LABEL')
    tva._value = request.form.get('VALUE')
    if (the_api.setVat(tva)):
        vats = the_api.getListVat()
        html = render_template("showvat.html", title="liste tvas", vats=vats)
    else:
        html = "<div><h1>ERREUR !!!</h1><br/>"
    return html
    

if __name__ == '__main__':
    app.run(debug=True)