<?php

class apiFreeOrders
{
    private $url_source = 'localhost:3000/root/MessageService/';
    public $curl;

    function getToken($appId) 
    {  
     curl_setopt_array($this->curl, array(
         CURLOPT_URL => $this->url_source.'getToken',
         CURLOPT_RETURNTRANSFER => true,
         CURLOPT_ENCODING => '',
         CURLOPT_MAXREDIRS => 10,
         CURLOPT_TIMEOUT => 0,
         CURLOPT_FOLLOWLOCATION => true,
         CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
         CURLOPT_CUSTOMREQUEST => 'POST',
         CURLOPT_POSTFIELDS =>'{"AppId":"'.$appId.'"}',//'{"AppId":"FBA76CA3-6438-4CDD-BB51-344C27B0CD69"}',
     ));

     $response = curl_exec($this->curl);

     return $response;
    }

    public function __construct() {
      $this->curl = curl_init();
    }

    function __destruct() {
      curl_close($this->curl);
    }

}
