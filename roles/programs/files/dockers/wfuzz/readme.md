- First time use: `docker-compose up --build`
- Afterward, use `docker-compose up`

Wfuzz reference: https://www.kali.org/tools/wfuzz and https://wfuzz.readthedocs.io/en/latest
- E.g., `wfuzz -c -w ./wordlists/discovery/common.txt --hc 404 https://192.168.1.202/FUZZ`
- Use `wfuzz --help` for more details
