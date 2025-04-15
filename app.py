import requests
from flask import Flask, request, jsonify
import logging 

# Create General Logger-- includes error and http (which includes access)
general_logger = logging.getLogger("GeneralLogger")

# anything INFO and more important will be logged (debug is lowest, critical is highest)
# allows us to filter what is logged
general_logger.setLevel(logging.DEBUG)

# defines which file is written to and in what format
general_handler = logging.FileHandler("general.log")
general_handler.setFormatter(logging.Formatter('%(asctime)s - GENERAL - %(levelname)s - %(message)s'))
general_logger.addHandler(general_handler)

app = Flask(__name__)

# function to run DCV at the current perspective and return a response when done 
@app.route('/validate', methods=['POST'])
def validate():

    data = request.json
    domain = data.get('domain')
    datacenter = data.get('datacenter')
    token = data.get('token')
    
    # ping the domain through an http post request 
    general_logger.debug(f"request to be sent: {request} \t")
    try: 
        response = requests.get(f"http://{domain}/.well-known/gca-challenge/{token}?datacenter={datacenter}", timeout=30)
        general_logger.debug(f"request succeeded, sending response: {response} \n")
        return {"status_code": response.status_code}, 200  
    except requests.exceptions.Timeout as e:
        general_logger.debug(f"request timed out with exception: {e} \n")
        return {"timeout": str(e)}, 408  
    except requests.exceptions.RequestException as e:
        general_logger.debug(f"request failed with exception: {e} \n")
        return {"request failed": str(e)}, 500  


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)