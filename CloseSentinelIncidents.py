#!/usr/bin/env python3

import requests

uri = "https://prod-100.westeurope.logic.azure.com:443/workflows/7094708afce94e4b8b71b7eb91c8fd90/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=CDZtlrIEpVptTpk5e-UgJ8FU5we4f9zv8lfV5kNdUMQ" # WIll BE GENERATED AFTER PLAYBOOK IS SAVED

json_payload = {
    "bulkoperation": {
        "operationtype": "kql",
        "operationquery": '''    
                            SecurityIncident
                    | where TimeGenerated between (ago(30d) .. now())
                    | where Status != "Closed"
                    | extend AlertID = tostring(parse_json(AlertIds)[0]) 
                    | join kind=innerunique SecurityAlert on $left.AlertID == $right.SystemAlertId
                    | where CompromisedEntity == "cis-cym.cc.technion.ac.il"
                    | parse IncidentUrl with  * "/Incident" IncidentArmID
                    | summarize by IncidentArmID, Severity, IncidentName, IncidentUrl, IncidentNumber

        ''',
        "operationstatus": "Closed"
    }
}

response = requests.post(uri, json=json_payload)

if response.status_code == 202:
    print("Request sent successfully.")
else:
    print("Request failed. Status code:", response.status_code)