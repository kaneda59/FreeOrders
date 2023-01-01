import json

class result_information:
    js = ''
    state = ''
    response = ''
    errorCode = '0000'
    error = ''
        
    def __init__(self, json_string):
        self.js = json_string        
        self.read()
        
    def read(self):        
        obj_python = self.js['result'][0]               
        self.state = obj_python['State']
        response =  json.loads(obj_python['response'])  
              
        if (self.state=='ok'):
            if "information" in response:
                self.response = response['information']
            else:
                self.response = response
        else:
            if "information" in response:
                self.response = response['information']
            else:
                self.response = response
        
        