<?php
$region = 'us-east-2';
echo "Our Landing page";
echo file_get_contents( 'php://input' );
echo "<h2>HTTP Request Metadata</h2>";
echo "<pre>";
#print_r($_SERVER);

#$sufix = $_SERVER['QUERY_STRING'];
#echo $sufix;

echo "</pre>";
#  phpinfo();

// Get the query string parameters
$name = $_GET['name'] ?? '';
$upstream = $_GET['upstream'] ?? '';

// Extract part of the name (if it contains "IKOPREPROD")
if (strpos($name, "PREPROD") !== false) {
    $trust_name = substr($name, strlen("/HealthRoster/"), strpos($name, "PREPROD") - strlen("/HealthRoster/"));
#$trust_name = substr($name, 0, strpos($name, "PREPROD"));
} else {
    header("HTTP/1.1 502 Bad Gateway");
    exit("502 Error: Invalid name in query string.");
}

// Extract the IP address part of the upstream variable
$upstream_ip = strtok($upstream, ':');


echo $trust_name;
echo "<br />";
echo $upstream_ip;

echo "<br />";

$forwarded_for = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? 'Unknown';

echo $forwarded_for;

#####################################################################################
// Get the upstream IP address
$upstream_ip = '172.31.24.204';  // Example IP, replace with the actual one you're using
#this block needs to be removed
#################################################################################

// Find the instance with the upstream IP address
$instance_status = exec("aws ec2 describe-instances --filters Name=private-ip-address,Values=$upstream_ip --query 'Reservations[*].Instances[*].State.Name' --output text --region $region");

if ($instance_status == 'stopped') {
    // Display message and button to start the instance
    echo "<html>";
    echo "<head><title>Instance Stopped</title></head>";
    echo "<body>";
    echo "<h2>The instance is currently stopped.</h2>";
    echo "<form method='post'>";
    echo "<input type='submit' name='start_instance' value='Start Instance' />";
    echo "</form>";
    echo "</body>";
    echo "</html>";
    
    // If the button is clicked, start the instance
    if (isset($_POST['start_instance'])) {
        $instance_id = exec("aws ec2 describe-instances --filters Name=private-ip-address,Values=$upstream_ip --query 'Reservations[*].Instances[*].InstanceId' --output text --region $region");
        exec("aws ec2 start-instances --instance-ids $instance_id --region $region");
        echo "Instance is starting...";

	$health_check_url = "https://{$_SERVER['HTTP_HOST']}/HealthRoster/{$trust_name}PREPROD";
	echo $health_check_url;
##########################################################################################
$health_check_url = 'https://sales.allocate-cloud.co.uk/HealthRoster/PRESALES/Login.aspx';
# this block needs to be remove as well
#############################################################################################
	$instance_ready = false;

	while (!$instance_ready) { // this check is potential loop issue since it has forward to landpage. Redines to be checked wit aws cli.
    		$response_code = exec("curl -o /dev/null -s -w \"%{http_code}\" $health_check_url");

    		if ($response_code != "5[0-9][0-9]") {
			$instance_ready = true;
			$instance_status_new = exec("aws ec2 describe-instances --filters Name=private-ip-address,Values=$upstream_ip --query 'Reservations[*].Instances[*].State.Name' --output text --region $region");
			// Prepare log data
			$log_data = [
			    'timestamp' => date('Y-m-d H:i:s'),
			    'name' => $trust_name,
			    'upstream_ip' => $upstream_ip,
			    'forwarded_for' => $forwarded_for,
			    'instance_status' => $instance_status,
			    'instance_status_new' => $instance_status_new
			];

			// Write the log data into a file
			file_put_contents('/home/ubuntu/nginx_specific.log', implode(",", $log_data) . PHP_EOL, FILE_APPEND);
    		} else {
        		sleep(5);  // Wait for 5 seconds before the next check
    		}
	}

// Forward the client to the health check URL
	header("Location: $health_check_url");
	exit;
    } 
} elseif ($instance_status == 'running') {
	echo "<br />";
    echo "The instance is already running.";
} else {
	echo "<br />";
    echo "Instance state: $instance_status";
    exit;  // Do nothing if the instance is in other states
}

// Prepare log data
$log_data = [
    'timestamp' => date('Y-m-d H:i:s'),
    'name' => $trust_name,
    'upstream_ip' => $upstream_ip,
    'forwarded_for' => $forwarded_for,
    'instance_status' => $instance_status,
    'instance_status_new' => $instance_status_new
];


?>
