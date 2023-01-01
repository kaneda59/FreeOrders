<html>
    <head></head>
    <body>
        <?php
           include './microsvc/cli.datas.php';
           $api = new apiFreeOrders();
           echo $api->getToken('');
        ?>
    </body>
</html>