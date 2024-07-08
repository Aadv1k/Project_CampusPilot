### Quicksetup

You need [Redis](https://redis.io/) for the OTP system to work. 

Assuming it is installed, start it like so

```
sudo service redis-server start
```

the `.env` file needs to be setup like so:

```

    # find this a 
TWILIO_SID="[SID]"
TWILIO_AUTH_TOKEN="[AuthToken]"
TWILIO_FROM_NUMBER="[FromPhoneNumber]"
```

