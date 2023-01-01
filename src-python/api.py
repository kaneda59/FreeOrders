# --------------------------------------------------------------
# Unité API permettant de se connecter à l'API MessageService
# réalisé par Kaneda. © 2022. FDevelopment LTD
# projet démo : freeOrders. 
# --------------------------------------------------------------
import json
import requests
import result_information as rsi
import param_information as pri
from types import SimpleNamespace
import vat as v
import item as i
import supplier as s
import customer as c
import family as f

class api:
    target_url = 'http://localhost:3000/root/MessageService/'
    appID = 'FBA76CA3-6438-4CDD-BB51-344C27B0CD69'
    
    # security
    def gettoken(self, ID):
        read = requests.get(self.target_url + 'getToken?AppID=' + ID)
        return read.json() 
    
    def _token(self):
        response = rsi.result_information(self.gettoken(self.appID))
        if (response.state=='ok'):
            token = response.response
        else:
            token = '' 
        return token
    # preprare parameters from get element
    def getParameters(self, ID):
        token = self._token()  
        param = pri.param_information(self.appID, ID, token, '')
        return param.JSonValue()
    
    # get a generic object
    def getObject(self, object_name, parameters):
        read = requests.post(self.target_url + 'get' + object_name, json=json.loads(parameters))       
        response = rsi.result_information(read.json())        
        information = json.dumps(response.response)
        
        return response.state, information
    
    # set a generic object
    def setObject(self, object_name, object):  
    
        parameters = pri.param_extend_information(self.appID, object._id, self._token(), object.JSonValue())                                
        requests.post(self.target_url + 'set' + object_name, json=parameters.JSonValue())
                
        return 'ok', ''
    
    ##### --------------------------------------- requêtes de l'API ---------------------------------------
        
    def getVat(self, ID):                
        state, information = self.getObject('Vat', self.getParameters(ID))
        
        if (state == 'ok'):            
            tva = json.loads(information, object_hook=lambda d: SimpleNamespace(**d))
        else:
            tva = v.vat()
        return tva
    
    def getItem(self, ID):        
        state, information = self.getObject('Item', self.getParameters(ID))
        
        if (state == 'ok'):            
            item = json.loads(information, object_hook=lambda d: SimpleNamespace(**d))
        else:
            item = i.item()
        return item
    
    def getSupplier(self, ID):
        state, information = self.getObject('Supplier', self.getParameters(ID))
        
        if (state == 'ok'):            
            supp = json.loads(information, object_hook=lambda d: SimpleNamespace(**d))
        else:
            supp = s.supplier()
        return supp
    
    def getCustomer(self, ID):
        state, information = self.getObject('Customer', self.getParameters(ID))
        
        if (state == 'ok'):            
            cust = json.loads(information, object_hook=lambda d: SimpleNamespace(**d))
        else:
            cust = c.customer()
        return cust
    
    def getFamily(self, ID):
        state, information = self.getObject('Family', self.getParameters(ID))
        
        if (state == 'ok'):            
            fam = json.loads(information, object_hook=lambda d: SimpleNamespace(**d))
        else:
            fam = f.family()
        return fam
    
    # get a list of elements
    def getListVat(self):
        
        state, information = self.getObject('ListVat', self.getParameters(0))
                      
        if (state == 'ok'):              
            list = json.loads(information, object_hook=lambda d: SimpleNamespace(**d)) 
        else:
            list = []
        return list
    
    def getListItems(self):
        
        state, information = self.getObject('ListItems', self.getParameters(0))
                      
        if (state == 'ok'):              
            list = json.loads(information, object_hook=lambda d: SimpleNamespace(**d)) 
        else:
            list = []
        return list   
    
    def setVat(self, object):                
        state, information = self.setObject('Vat', object)
        
        if (state == 'ok'):            
            maj = True
        else:
            maj = False
        return maj 
                        
            
    
    
        
    
            
    

        
    
        
        
        
    



