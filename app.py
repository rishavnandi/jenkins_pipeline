from flask import Flask, render_template, request
import yfinance as yf

app = Flask(__name__)


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        ticker = request.form['ticker']
        stock = yf.Ticker(ticker)
        df = stock.history(period='max')
        return render_template('index.html', ticker=ticker, data=df.to_html(classes='table table-striped'))
    return render_template('index.html')


if __name__ == '__main__':
    app.run(debug=False)
