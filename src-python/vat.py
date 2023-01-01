import json

class vat:
    _id = 0
    _label = ''
    _value = 0
    
    def __init__(self):
        self._id = 0
        self._label = 0
        self._value = 0
        
    def JSonValue(self):        
        return json.dumps(self.__dict__)
    
    
        
    