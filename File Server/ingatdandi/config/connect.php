<?php

define('HOST','localhost');
define('USER','root');
define('PASS','');
define('DB','db_dandi');

$con = mysqli_connect(HOST,USER,PASS,DB) or die('Gagal konek dengan database ~dandi');

?>