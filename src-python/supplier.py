import json

class supplier:
    
    
    def __init__(self):
        self._id = 0
        self._Label = ''
        self._Description = ''
        self._Address = ''
        self._supplement = ''
        self._ZipCode = ''
        self._City = ''
        self._Country = ''
        self._Phone = ''
        self._Mobile = ''
        self._Account = ''
        self._mail = ''
        
    def JSonValue(self):        
        return json.dumps(self.__dict__)