# Input dictionary with region names and their corresponding IPs
# REPLACE WITH THE GENERATED PUBLIC IP ADDRESSES FROM TOFU (NEED TO ADD COMMAS)
region_ips = {
  "asia-east": "52.175.39.181",
  "asia-southeast": "52.163.118.152",
  "australia-central": "20.28.19.238",
  "australia-east": "20.191.232.6",
  "australia-southeast": "13.77.0.172",
  "brazil-south": "104.41.31.138",
  "canada-central": "4.206.43.128",
  "europe-north": "40.69.5.143",
  "europe-west": "52.137.53.146",
  "france-central": "40.89.171.185",
  "germany-westcentral": "131.189.118.142",
  "india-central": "4.247.164.80",
  "india-south": "13.71.112.212",
  "indonesia-central": "70.153.184.222",
  "israel-central": "20.217.201.12",
  "italy-north": "72.146.22.114",
  "japan-east": "74.176.197.58",
  "japan-west": "40.74.132.9",
  "korea-central": "20.39.201.177",
  "mexico-central": "158.23.92.31",
  "newzealand-north": "172.204.93.77",
  "norway-east": "51.107.213.251",
  "poland-central": "20.215.244.8",
  "southafrica-north": "4.221.59.84",
  "spain-central": "68.221.142.83",
  "sweden-central": "20.240.234.230",
  "switzerland-north": "51.103.183.56",
  "uae-north": "4.161.39.99",
  "uk-south": "4.234.200.177",
  "uk-west": "20.117.56.63",
  "us-central": "40.122.71.63",
  "us-east": "52.168.70.48",
  "us-east2": "135.119.138.18",
  "us-northcentral": "20.25.201.36",
  "us-southcentral": "104.214.102.190",
  "us-west": "172.184.200.7",
  "us-west2": "13.66.218.23",
  "us-west3": "20.163.70.18",
  "us-westcentral": "52.161.165.215"
}



# Create a new dictionary with the desired format
formatted_dict = {}

# Iterate over each region and its corresponding IP, reformatting the keys
for region, ip in region_ips.items():
    formatted_dict[f"vm-{region}"] = ip

# Print the formatted dictionary in the desired output format
for region, ip in formatted_dict.items():
    print(f'["{region}"]="{ip}"')
