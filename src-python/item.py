import json

class item:
    
    
    def __init__(self):
        self._id = 0
        self._Code = ''
        self._Label = ''
        self._description = ''
        self._pvht = 0
        self._paht= 0
        self._idvat = 0
        self._actif = False
        self._idfamily = 0
        self._idSupplier = 0
        
    def JSonValue(self):        
        return json.dumps(self.__dict__)