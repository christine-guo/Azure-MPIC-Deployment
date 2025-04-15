import requests
from flask import Flask, request, jsonify
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
import traceback
import os
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

# dictionary of all VM URLs + datacenters [need to manually edit w/ each deployment]
all_vms = {
    "http://10.0.1.4:5000": "australia-central",
    "http://10.1.1.4:5000": "australia-east",
    "http://10.2.1.4:5000": "australia-southeast",
    "http://10.3.1.4:5000": "brazil-south",
    "http://10.4.1.4:5000": "canada-central",
    # "http://10.5.1.4:5000": "canada-east",
    "http://10.6.1.4:5000": "india-central",
    "http://10.7.1.4:5000": "us-central",
    "http://10.8.1.4:5000": "asia-east",
    "http://10.9.1.4:5000": "asia-southeast",
    "http://10.10.1.4:5000": "us-east",
    "http://10.11.1.4:5000": "us-east2",
    "http://10.12.1.4:5000": "france-central",
    "http://10.13.1.4:5000": "germany-westcentral",
    "http://10.14.1.4:5000": "indonesia-central",
    "http://10.15.1.4:5000": "israel-central",
    "http://10.16.1.4:5000": "italy-north",
    "http://10.17.1.4:5000": "japan-east",
    "http://10.18.1.4:5000": "japan-west",
    "http://10.19.1.4:5000": "korea-central",
    # "http://10.20.1.4:5000": "korea-south",
    "http://10.21.1.4:5000": "mexico-central",
    "http://10.22.1.4:5000": "newzealand-north",
    "http://10.23.1.4:5000": "norway-east",
    "http://10.24.1.4:5000": "us-northcentral",
    "http://10.25.1.4:5000": "europe-north",
    "http://10.26.1.4:5000": "poland-central",
    # "http://10.27.1.4:5000": "qatar-central",
    "http://10.28.1.4:5000": "southafrica-north",
    "http://10.29.1.4:5000": "us-southcentral",
    "http://10.30.1.4:5000": "india-south",
    "http://10.31.1.4:5000": "spain-central",
    "http://10.32.1.4:5000": "sweden-central",
    "http://10.33.1.4:5000": "switzerland-north",
    "http://10.34.1.4:5000": "uae-north",
    "http://10.35.1.4:5000": "uk-south",
    "http://10.36.1.4:5000": "uk-west",
    "http://10.37.1.4:5000": "us-westcentral",
    "http://10.38.1.4:5000": "europe-west",
    # "http://10.39.1.4:5000": "india-west",
    "http://10.40.1.4:5000": "us-west",
    "http://10.41.1.4:5000": "us-west2",
    "http://10.42.1.4:5000": "us-west3"
}


# sends a http post request to validate the domain at the given VM
def send_request(vm_url, domain, datacenter, token):
    json_data = {
        "domain": domain, 
        "token": token, 
        "datacenter": datacenter
    }
    try:
        response = requests.post(f"{vm_url}/validate", json=json_data, timeout=30)
        return datacenter, response.status_code
    except requests.exceptions.Timeout as e:
        return datacenter, 408  
    except requests.exceptions.RequestException as e:
        return datacenter, 500  


# function to begin running DCV at all 7 GCP perspectives 
@app.route('/run-all', methods=['POST'])
def runAll():
    data = request.json
    domain = data.get('domain')
    token = data.get('token')
    node_a = data.get('node_a')
    node_b = data.get('node_b')

    errors = []
    server_error_flag = False

    # send DCV requests to all VMs and wait for their completion
    with ThreadPoolExecutor() as executor:
        futures = {executor.submit(send_request, vm_url, domain, datacenter, token): (vm_url, datacenter) for vm_url, datacenter in all_vms.items()}
        for future in futures:
            vm_url, datacenter = futures[future]
            try:
                datacenter, status_code = future.result()  
                if status_code != 200:
                    errors.append(f"dcv at {datacenter} failed with status code {status_code}")
            except Exception as e: 
                server_error_flag = True
                errors.append(f"internal server error: {str(e)}")
                # log exceptions to a file   
                general_logger.debug(f"request to run dcv at {datacenter} failed with exception: {e} \t") 
                general_logger.debug(traceback.format_exception_only(type(e), e, e.__traceback__))

    general_logger.debug(f"certificate request received from client: {data} \t")
    if server_error_flag:
        general_logger.debug(f"full dcv completed with status code 501: {errors}\n")
        return jsonify({"message": "internal server error occurred", "errors": errors}), 501 
    if errors:
        general_logger.debug(f"full dcv completed with status code 207, failed_vps: {errors}\n")
        return jsonify({"message": "DCV failed at some perspectives", "failed_vps": errors}), 207 
    else:
        general_logger.debug(f"full dcv completed with status code 200\n")
        return jsonify({"message": "DCV completed at all 39 Azure perspectives!"}), 200 

        
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