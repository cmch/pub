#!/bin/bash
rsync -r -e 'ssh -l ec2-user -i /home/colin/webkey.pem' ~/pub/projects/pitchfork-csv ec2-user@52.26.29.32:/home/ec2-user/
rsync -r -e 'ssh -l ec2-user -i /home/colin/webkey.pem' ~/.aws ec2-user@52.26.29.32:/home/ec2-user/
ssh -l ec2-user -i ~/webkey.pem 'sudo /home/ec2-user/pitchfork-csv/cron-install.sh'
