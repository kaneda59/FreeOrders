import json

class family:
        
    def __init__(self):
        self._id = 0
        self._Code = ''
        self._Label = ''
        self._description = ''
        
    def JSonValue(self):        
        return json.dumps(self.__dict__)