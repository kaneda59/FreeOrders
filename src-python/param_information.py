import json

class param_def:
    def __init__(self, id, token, information):
        self.id = id
        self.token = token
        self.information = information

class param_information:
   
    def __init__(self, appID, id, token, information):
        self.AppID = appID
        par = param_def(id, token, information)         
        self.AJSonString = json.dumps(par.__dict__)           
        
    def JSonValue(self):
        return  json.dumps(self.__dict__)
    
class param_extend_information:
    
    def __init__(self, appID, id, token, information):
        self.AppID = appID
        par = param_def(id, token, information)
        self.AJSonString = json.dumps(par.__dict__)
        self.information = information
        
    def JSonValue(self):
        return json.dumps(self.__dict__)
        
    