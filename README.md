# Django-Demo

## Deploy the instance
- Install configure AWS credentials, install packer and install terraform
```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
sudo apt install packer
sudo apt install python python-pip python-setuptools
sudo pip install awscli
aws configure
```

- Generate key pair in AWS with name "webauto" :
```
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair
Note : Please download your private key file : webauto.pem
```

- Clone this repository, and run :
```
./deploy.sh
```

- Copy the ip of instance displayed and login on server using :
```
ssh -i webauto.pem admin@<ip>
```

- Update settings.py to allow instance ip as host :
```
sudo nano /var/www/html/dynamic/dynamic/settings.py

ALLOWED_HOSTS = ['ip', 'localhost']

sudo systemctl reload apache2
```

- Open IP in any browser

- View apache2 logs [sample logs shared below for success]:
```
43.246.161.77 - - [29/Dec/2021:09:12:10 +0000] "GET / HTTP/1.1" 200 547 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36"
43.246.161.77 - - [29/Dec/2021:09:12:11 +0000] "GET /favicon.ico HTTP/1.1" 404 2629 "http://15.206.100.99/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36"
43.246.161.77 - - [29/Dec/2021:09:13:02 +0000] "-" 408 0 "-" "-"
43.246.161.77 - - [29/Dec/2021:09:13:16 +0000] "GET /welcome?text=Sonali+Srivastava HTTP/1.1" 200 418 "http://15.206.100.99/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36"
```

