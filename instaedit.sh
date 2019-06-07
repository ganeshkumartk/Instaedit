# InstaEdit v1.0.0
# Author: @coderganesh
# https://github.com/coderganesh/instaedit

string4=$(openssl rand -hex 32 | cut -c 1-4)
string8=$(openssl rand -hex 32  | cut -c 1-8)
string12=$(openssl rand -hex 32 | cut -c 1-12)
string16=$(openssl rand -hex 32 | cut -c 1-16)
device="android-$string16"
uuid=$(openssl rand -hex 32 | cut -c 1-32)
phone="$string8-$string4-$string4-$string4-$string12"
guid="$string8-$string4-$string4-$string4-$string12"
var=$(curl -i -s -H "$header" https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid=$uuid > /dev/null)
var2=$(echo $var | awk -F ';' '{print $2}' | cut -d '=' -f3)

banner() {
printf "\n"
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] InstaEdit v1.0,\e[0m\e[1;92m Author: @coderganesh\n"
printf "\n"

}
start() {
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Username account: \e[0m' user
checkaccount=$(curl -L -s https://www.instagram.com/$user/ | grep -c "the page may have been removed")
if [[ "$checkaccount" == 1 ]]; then
printf "\e[1;91mInvalid Username! Try again\e[0m\n"
sleep 1
exit 1
fi
read -s -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Password: \e[0m' pass
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'

data='{"phone_id":"'$phone'", "_csrftoken":"'$var2'", "username":"'$user'", "guid":"'$guid'", "device_id":"'$device'", "password":"'$pass'", "login_attempt_count":"0"}'
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"


hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
useragent='User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'

var=$(curl -c cookie -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/accounts/login/" | grep -o "logged_in_user\|challenge\|many tries\|Please wait" | uniq );
 if [[ $var == "challenge" ]]; then printf "\e[1;92m \n[*] Login Successful!\n [*] But Challenge required! Exiting\n"; exit 1; elif [[ $var == "logged_in_user" ]]; then printf "\e[1;92m \n[*] Login Successful!\e[0m\n"; elif [[ $var == "Please wait" ]]; then printf "\e[1;93m \n [*] Please wait, ip blocked!\n"; fi

}

edit_profile() {
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Edit Profile:\e[0m\n"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Gender (male: 1, female: 2, Undef: 3): \e[0m' gender
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Phone: \e[0m' phone
IFS=$'\n'
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] First Name: \e[0m' first_name
IFS=$'\n'
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Bio: \e[0m' bio
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] External Url: \e[0m' external_url
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Email: \e[0m' email
data='{"username":"'$user'", "gender": "'$gender'", "phone_number": "'$phone'", "first_name": "'$first_name'", "biography": "'$bio'", "external_url": "'$external_url'", "email": "'$email'" }'
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"
hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
IFS=$'\n'
curl -b cookie -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/accounts/edit_profile/"

}
banner
start
edit_profile
