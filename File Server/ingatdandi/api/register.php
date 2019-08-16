<?php

require "../config/connect.php";

$userr = $_POST['username'];
$passs = $_POST['password'];

if(isset($_POST['login']))
{
		$ipldap = "ldap://10.15.3.120";
		$mydomain ='SMIG';
		$dcName ="dc=SMIG,dc=CORP";
		$ldap = ldap_connect($ipldap,389);

		$username =mysql_escape_string($userr);
		$password =(mysql_escape_string($passs));

		$ldaprdn = $mydomain . "\\" . $username;
	
		ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
		ldap_set_option($ldap, LDAP_OPT_REFERRALS, 0);
	
		$bind = @ldap_bind($ldap, $ldaprdn, $password);
		if ($bind) {
			$filter="(sAMAccountName=$username)";
			$result = ldap_search($ldap,$dcName,$filter);
			ldap_sort($ldap,$result,"sn");
			$info = ldap_get_entries($ldap, $result);
			for ($i=0; $i<$info["count"]; $i++)
			{
				if($info['count'] > 1)
				break;
				
				$nama = $info[$i]["cn"][0];
				
			}
			@ldap_close($ldap);

if ($_SERVER['REQUEST_METHOD']=="POST") {
    # code...

                    $usernya = $userr;
                    if ($usernya=="admin.jpa"){
                        $gas = "ruli.rahmadi";
                    }else{
                        $gas = $usernya;
                    }

                $sumber = 'http://dev-app.semenindonesia.com/dev/hris/page/semenPadang/apiKaryawanSP.php?email='.$gas;
                    $konten = file_get_contents($sumber);
                    $data = json_decode($konten, true);
                    $uk = $data[0]['muk_nama'];

    $responsee = array();
    $username = $_POST['username'];
    $password = md5($_POST['password']);
    $unitkerja = $uk;
    date_default_timezone_set("Asia/Jakarta");
    $date = date("Y-m-d");

    $cek = "SELECT * FROM users WHERE username = '$username'";
    $result = mysqli_fetch_array(mysqli_query($con,$cek));

    if (isset($result)) {
        # code...
        $responsee['value'] = 2;
        $responsee['message']="Username sudah terdaftar";
        echo json_encode($responsee);
    } else {
        # code...

        $insert = " INSERT INTO users VALUE (NULL,'$username','$password','$unitkerja','1','1','$date')";

    if (mysqli_query($con,$insert)) {
        # code...

        $responsee['value'] = 1;
        $responsee['message']="Berhasil didaftarkan";
        echo json_encode($responsee);
        echo "berhasil";

    } else {
        # code...

        $responsee['value'] = 0;
        $responsee['message']="Gagal didaftarkan";
        echo json_encode($responsee);

    }
    

    }
}

}
else
{
    echo "Login gagal";
}
}

?>