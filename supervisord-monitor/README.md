
# from supervisord-monitor
https://github.com/mlazarov/supervisord-monitor
# repo
https://github.com/banjocat/docker-devops-examples/tree/master/supervisord-monitor

## Required Environmental variables
| Variable | Syntax |What it does|
|----------|--------|------|
|SERVERS|server1=127.0.0.1,server2=localhost| List of servers by display_name=url|
|USERNAME|admin|username to login remove supervisord|
|PASSWORD|admin|password to login

## Optional Environmental variables
| Variable | Default |What it does|
|----------|--------|------|
|PORT| 9001 | Port to access supervisord|
|CONTACT_EMAIL| none@none.com | Change contact email link|
|SERVER_NAME | Support Center | Change banner bar title name|



## Example

      docker run -p "9000:80" -e SERVERS="server1=localhost" -e USERNAME=admin -e PASSWORD=admin banjocat/supervisord-monitor
